-- Terminal commands

-- sudo -u postgres psql
-- CREATE DATABASE event_scheduling_db;
-- \c event_scheduling_db
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- SQL queries

-- Tables

CREATE TABLE Events(
                       event_id UUID PRIMARY KEY,
                       title TEXT,
                       description JSONB,
                       venue_id UUID REFERENCES Venues(venue_id),
                       organizer_id UUID REFERENCES Organizers(organizer_id),
                       schedule tsrange
);

CREATE TABLE Attendees(
                          attendee_id UUID PRIMARY KEY,
                          name TEXT,
                          email TEXT,
                          preferences JSONB,
                          tickets UUID[]
);

CREATE TABLE Venues(
                       venue_id UUID PRIMARY KEY,
                       name TEXT,
                       location JSONB,
                       capacity INT,
                       contact_info TEXT[]
);

CREATE TABLE Organizers(
                           organizer_id UUID PRIMARY KEY,
                           name TEXT,
                           contact_info JSONB
);

CREATE TABLE Event_Schedules (
                                 schedule_id UUID PRIMARY KEY,
                                 event_id UUID REFERENCES Events(event_id),
                                 start_time TIMESTAMPTZ,
                                 end_time TIMESTAMPTZ,
                                 description TEXT
);

CREATE TABLE Tickets (
                         ticket_id UUID PRIMARY KEY,
                         event_id UUID REFERENCES Events(event_id),
                         attendee_id UUID REFERENCES Attendees(attendee_id),
                         price NUMERIC,
                         status status
);

CREATE TABLE Reviews(
                        review_id UUID PRIMARY KEY,
                        event_id UUID REFERENCES Events(event_id),
                        attendee_id UUID REFERENCES Attendees(attendee_id),
                        rating rating,
                        comment TEXT
);

CREATE TABLE User_Preferences(
                                 user_id UUID PRIMARY KEY REFERENCES Attendees(attendee_id),
                                 interests TEXT[],
                                 notifications_enabled BOOLEAN
);


CREATE TYPE status AS ENUM ('available', 'sold', 'reserved');
CREATE TYPE rating AS ENUM ('poor', 'fair', 'good', 'excellent');

-- Insertions

-- Events
INSERT INTO Events (event_id, title, description, venue_id, organizer_id, schedule)
VALUES
    (uuid_generate_v4(), 'One Piece Convention', '{"topics":["Anime", "Manga"]}', (SELECT venue_id FROM Venues WHERE name = 'Grand Line Exhibition Hall'), (SELECT organizer_id FROM Organizers WHERE name = 'Straw Hat Events'), '[2023-07-15 10:00, 2023-07-15 18:00]'),
    (uuid_generate_v4(), 'Pirate Music Festival', '{"genres":["Sea Shanties", "Adventure"]}', (SELECT venue_id FROM Venues WHERE name = 'Sunny Village Outdoor Stage'), (SELECT organizer_id FROM Organizers WHERE name = 'Grand Line Productions'), '[2023-07-20 12:00, 2023-07-20 23:00]'),
    (uuid_generate_v4(), 'Marine Summit', '{"topics":["World Government", "Justice"]}', (SELECT venue_id FROM Venues WHERE name = 'Marineford Stadium'), (SELECT organizer_id FROM Organizers WHERE name = 'World Government Events'), '[2023-08-10 09:00, 2023-08-10 17:00]'),
    (uuid_generate_v4(), 'Sabo Art Exhibition', '{"genres":["Painting", "Revolutionary Art"]}', (SELECT venue_id FROM Venues WHERE name = 'Revolutionary Hideout'), (SELECT organizer_id FROM Organizers WHERE name = 'Revolutionary Army Events'), '[2023-09-05 11:00, 2023-09-05 20:00]'),
    (uuid_generate_v4(), 'Devil Fruit Expo', '{"topics":["Devil Fruits", "Powers"]}', (SELECT venue_id FROM Venues WHERE name = 'Baratie Restaurant'), (SELECT organizer_id FROM Organizers WHERE name = 'Devil Fruit Expo'), '[2023-10-15 12:00, 2023-10-15 19:00]');



-- Attendees
INSERT INTO Attendees (attendee_id, name, email, preferences, tickets)
VALUES
    (uuid_generate_v4(), 'Monkey D. Luffy', 'luffy@example.com', '{"interests":["Adventure", "Eating"]}', ARRAY[UUID '43d82617-98a8-475f-b982-874f4e881dd8', UUID '5e09badd-618d-4da0-bb91-1fd8a4e8b405']),
    (uuid_generate_v4(), 'Roronoa Zoro', 'zoro@example.com', '{"interests":["Swordsmanship", "Napping"]}', ARRAY[UUID 'ac6703aa-3b96-4da9-9e69-530d5b109024']),
    (uuid_generate_v4(), 'Nami', 'nami@example.com', '{"interests":["Navigation", "Treasure"]}', ARRAY[UUID 'e29db77a-ff1d-42ed-9ed6-811919b9caf0']),
    (uuid_generate_v4(), 'Usopp', 'usopp@example.com', '{"interests":["Sniping", "Storytelling"]}', ARRAY[UUID 'e29db77a-ff1d-42ed-9ed6-811919b9caf0']),
    (uuid_generate_v4(), 'Sanji', 'sanji@example.com', '{"interests":["Cooking", "Ladies"]}', ARRAY[UUID 'fd76d34e-03bf-4667-b9cd-6a3d1af5172a']);



-- Venues
INSERT INTO Venues (venue_id, name, location, capacity, contact_info)
VALUES
    (uuid_generate_v4(), 'Grand Line Exhibition Hall', '{"city":"Water 7", "island":"Water 7"}', 1000, ARRAY['+1234567', '+09876543']),
    (uuid_generate_v4(), 'Sunny Village Outdoor Stage', '{"island":"Sunny Village"}', 800, ARRAY['+11111111']),
    (uuid_generate_v4(), 'Marineford Stadium', '{"island":"Marineford"}', 1500, ARRAY['+3333333', '+22222222']),
    (uuid_generate_v4(), 'Revolutionary Hideout', '{"island":"Baltigo"}', 500, ARRAY['+4444444', '+55555555']),
    (uuid_generate_v4(), 'Baratie Restaurant', '{"island":"Baratie"}', 200, ARRAY['+6666666', '+77777777']);

-- Organizers
INSERT INTO Organizers (organizer_id, name, contact_info)
VALUES
    (uuid_generate_v4(), 'Straw Hat Events', '{"email":"info@strawhatevents.com"}'),
    (uuid_generate_v4(), 'Grand Line Productions', '{"email":"info@grandlineproductions.com"}'),
    (uuid_generate_v4(), 'World Government Events', '{"email":"info@worldgoverment.com"}'),
    (uuid_generate_v4(), 'Revolutionary Army Events', '{"email":"info@marine.com"}'),
    (uuid_generate_v4(), 'Devil Fruit Expo', '{"email":"info@devilsfruit.com"}');

-- Event_Schedules
INSERT INTO Event_Schedules (schedule_id, event_id, start_time, end_time, description)
VALUES
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'One Piece Convention' LIMIT 1), '2023-07-15 10:00', '2023-07-15 18:00', 'Day of Fun and Adventure'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Pirate Music Festival' LIMIT 1), '2023-07-20 12:00', '2023-07-20 23:00', 'Musical Extravaganza'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Marine Summit' LIMIT 1), '2023-08-10 09:00', '2023-08-10 17:00', 'Meeting of the World Leaders'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Sabo Art Exhibition' LIMIT 1), '2023-09-05 11:00', '2023-09-05 20:00', 'Art and Revolution'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Devil Fruit Expo' LIMIT 1), '2023-10-15 12:00', '2023-10-15 19:00', 'Exhibition of Powers');

-- Tickets
INSERT INTO Tickets (ticket_id, event_id, attendee_id, price, status)
VALUES
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'One Piece Convention' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Monkey D. Luffy' LIMIT 1), 50.00, 'available'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Devil Fruit Expo' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Roronoa Zoro' LIMIT 1), 50.00, 'sold'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Pirate Music Festival' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Monkey D. Luffy' LIMIT 1), 30.00, 'reserved'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Marine Summit' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Nami' LIMIT 1), 100.00, 'available'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Sabo Art Exhibition' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Usopp' LIMIT 1), 75.00, 'available');

-- Reviews
INSERT INTO Reviews (review_id, event_id, attendee_id, rating, comment)
VALUES
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'One Piece Convention' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Monkey D. Luffy' LIMIT 1), 'excellent', 'Best convention ever!'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Pirate Music Festival' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Nami' LIMIT 1), 'good', 'Great music and atmosphere'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Marine Summit' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Usopp' LIMIT 1), 'excellent', 'Very informative and well organized'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Sabo Art Exhibition' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Sanji' LIMIT 1), 'good', 'Beautiful art and inspiring'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Devil Fruit Expo' LIMIT 1), (SELECT attendee_id FROM Attendees WHERE name = 'Sanji' LIMIT 1), 'excellent', 'Amazing powers and displays');



-- User_Preferences
INSERT INTO User_Preferences (user_id, interests, notifications_enabled)
VALUES
    ((SELECT attendee_id FROM Attendees WHERE name = 'Monkey D. Luffy' LIMIT 1), ARRAY['Adventure', 'Eating'], true),
    ((SELECT attendee_id FROM Attendees WHERE name = 'Roronoa Zoro' LIMIT 1), ARRAY['Swordsmanship', 'Napping'], false),
    ((SELECT attendee_id FROM Attendees WHERE name = 'Nami' LIMIT 1), ARRAY['Navigation', 'Treasure'], true),
    ((SELECT attendee_id FROM Attendees WHERE name = 'Usopp' LIMIT 1), ARRAY['Sniping', 'Storytelling'], true),
    ((SELECT attendee_id FROM Attendees WHERE name = 'Sanji' LIMIT 1), ARRAY['Cooking', 'Ladies'], false);

-- Queries

SELECT * FROM Events WHERE schedule <@ '[2023-10-01, 2023-10-31]';

SELECT * FROM Attendees WHERE preferences->'interests' @> '["Adventure"]';


SELECT * FROM Attendees WHERE preferences->'interests' @> '["Adventure"]';


SELECT contact_info FROM Organizers WHERE organizer_id = (SELECT organizer_id FROM Events WHERE title = 'Sabo Art Exhibition');


SELECT * FROM Events WHERE event_id IN (SELECT event_id FROM Tickets WHERE status = 'available');

SELECT * FROM Reviews WHERE event_id = (SELECT event_id FROM Events WHERE title = 'One Piece Convention') ORDER BY rating;

UPDATE Event_Schedules SET start_time = '2023-07-15 09:00', end_time = '2023-07-15 17:00' WHERE event_id = '0dc6c6db-f6d1-46e8-9a35-033089e4bef1';

SELECT * FROM User_Preferences WHERE notifications_enabled = true;

SELECT event_id, COUNT(*) AS total_tickets_sold FROM Tickets WHERE status = 'sold' GROUP BY event_id;

SELECT Events.* FROM Events
                         JOIN Tickets ON Events.event_id = Tickets.event_id
WHERE Tickets.attendee_id = 'a00badd1-2ed2-49a9-99a9-606722c2a2c9';