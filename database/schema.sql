CREATE TABLE IF NOT EXISTS Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Tasks (
    TaskID SERIAL PRIMARY KEY,
    UserID INT,
    Title VARCHAR(50) NOT NULL,
    Description TEXT,
    Priority VARCHAR(50),
    DueDate DATE,
    STATUS VARCHAR(50),
    CATEGORY VARCHAR(50),
    FOREIGN KEY (UserID) references Users(UserID)
);

CREATE TABLE IF NOT EXISTS Events (
    EventID SERIAL PRIMARY KEY,
    UserID INT,
    Title VARCHAR(50) NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    Category VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE IF NOT EXISTS TaskHabits (
    TaskHabitID SERIAL PRIMARY KEY,
    TaskID INT,
    TimesSnoozed INT DEFAULT 0,
    TimesMissedDeadline INT DEFAULT 0,
    TimesCompletedEarly INT DEFAULT 0,
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID)
);

CREATE TABLE IF NOT EXISTS EventHabits (
    EventHabitID SERIAL PRIMARY KEY,
    EventID INT,
    TimesLate INT DEFAULT 0,
    TimesEarly INT DEFAULT 0,
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

CREATE TABLE IF NOT EXISTS Recommendations (
    RecommendationID SERIAL PRIMARY KEY,
    UserID INT,
    RecommendationType VARCHAR(50), --Classifies the type of recommendation (Optimal task time, general advice, etc)
    Description TEXT,
    RelatedEntityID INT, --Category for the type of entity that the recommendation is for. (Event/Task)
    Insight TEXT, --Lets the user know what influenced the recommendation
    Priority VARCHAR(50), --How important is the recommendation?
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE IF NOT EXISTS UserPreferences (
    UserID SERIAL PRIMARY KEY,
    Theme VARCHAR(50),
    TimeBudget INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE INDEX IF NOT EXISTS idx_tasks_userid_priority_duedate ON Tasks(UserID, Priority, DueDate);
CREATE INDEX IF NOT EXISTS idx_events_userid_starttime ON Events(UserID, StartTime);

CREATE VIEW IF NOT EXISTS UserActivities AS
SELECT 
    u.UserID, u.Username, 
    t.Title AS TaskTitle, t.DueDate, t.Status, 
    e.Title AS EventTitle, e.StartTime, e.EndTime
FROM 
    Users u
LEFT JOIN 
    Tasks t ON u.UserID = t.UserID
LEFT JOIN 
    Events e ON u.UserID = e.UserID;
