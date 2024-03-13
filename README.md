# event-scheduling



# Assignment: Events Scheduling Database Design

## Objective

Design a PostgreSQL database for an event scheduling application. This database will incorporate advanced data types to manage events, attendees, venues, and more. You are expected to create a schema that includes 8 tables, each with at least 5 records. Additionally, you will write 10 queries to demonstrate how to interact with the database effectively.

## Database Schema

### Tables Overview

1. **Events**
2. **Attendees**
3. **Venues**
4. **Organizers**
5. **Event_Schedules**
6. **Tickets**
7. **Reviews**
8. **User_Preferences**

### Table Definitions

1. **Events**
    - event_id: UUID
    - title: TEXT
    - description: JSONB
    - venue_id: UUID (FK)
    - organizer_id: UUID (FK)
    - schedule: tsrange

2. **Attendees**
    - attendee_id: UUID
    - name: TEXT
    - email: TEXT
    - preferences: JSONB
    - tickets: UUID[]

3. **Venues**
    - venue_id: UUID
    - name: TEXT
    - location: JSONB
    - capacity: INTEGER
    - contact_info: TEXT[]

4. **Organizers**
    - organizer_id: UUID
    - name: TEXT
    - contact_info: JSONB

5. **Event_Schedules**
    - schedule_id: UUID
    - event_id: UUID (FK)
    - start_time: TIMESTAMPTZ
    - end_time: TIMESTAMPTZ
    - description: TEXT

6. **Tickets**
    - ticket_id: UUID
    - event_id: UUID (FK)
    - attendee_id: UUID (FK)
    - price: NUMERIC
    - status: ENUM ('available', 'sold', 'reserved')

7. **Reviews**
    - review_id: UUID
    - event_id: UUID (FK)
    - attendee_id: UUID (FK)
    - rating: ENUM ('poor', 'fair', 'good', 'excellent')
    - comment: TEXT

8. **User_Preferences**
    - user_id: UUID (FK -> Attendees)
    - interests: TEXT[]
    - notifications_enabled: BOOLEAN

## Sample Records Insertion

For each table, insert at least 5 records. Here's an example for the **Events** table:

```sql
INSERT INTO events (event_id, title, description, venue_id, organizer_id, schedule) VALUES
('uuid-1', 'Tech Conference', '{"topics":["AI", "Cloud"]}', 'venue-uuid-1', 'org-uuid-1', '[2023-10-01 09:00, 2023-10-01 17:00]'),
('uuid-2', 'Music Festival', '{"genres":["Rock", "Pop"]}', 'venue-uuid-2', 'org-uuid-2', '[2023-08-05 12:00, 2023-08-05 23:00]');
```

## Queries

1. **Find all events happening in October 2023.**
2. **List attendees who have 'Music' as an interest.**
3. **Retrieve all venues with a capacity greater than 500.**
4. **Get the contact information for organizers of 'Tech Conference'.**
5. **Find all events with tickets still available.**
6. **List all reviews for a specific event, ordered by rating.**
7. **Update the schedule for an event.**
8. **Find attendees who have enabled notifications.**
9. **Retrieve the total number of tickets sold for each event.**
10. **List all events an attendee is going to, based on their ticket purchases.**

## Assignment Tasks

1. **Design the database schema**: Create the tables as defined above, ensuring proper data types and relationships are used.
2. **Insert sample data**: Populate each table with at least 5 records.
3. **Write queries**: Construct the 10 queries listed above to interact with the database.

## Submission Guidelines

- Submit the SQL scripts for creating tables, inserting data, and the queries.
- Include a diagram of the database schema showing tables, columns, and relationships.
- Ensure your queries are well-commented to explain their purpose and functionality.

This assignment will test your ability to design a comprehensive database schema using advanced PostgreSQL features and interact with the database through complex queries.
