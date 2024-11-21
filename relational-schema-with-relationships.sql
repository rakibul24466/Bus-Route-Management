-- One-to-One Relationships
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin', 'passenger') NOT NULL
);

CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY,
    user_id INT UNIQUE,  -- UNIQUE constraint ensures one-to-one relationship
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address TEXT,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
    user_id INT UNIQUE,  -- UNIQUE constraint ensures one-to-one relationship
    department VARCHAR(50),
    access_level VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- One-to-Many Relationships
CREATE TABLE Bus (
    bus_id INT PRIMARY KEY,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    capacity INT NOT NULL,
    model VARCHAR(50),
    status ENUM('available', 'on_trip', 'maintenance') NOT NULL
);

CREATE TABLE Bus_Features (
    feature_id INT PRIMARY KEY,
    bus_id INT,
    feature VARCHAR(50),
    FOREIGN KEY (bus_id) REFERENCES Bus(bus_id)
);

CREATE TABLE Seat (
    seat_id INT PRIMARY KEY,
    bus_id INT,
    seat_number INT NOT NULL,
    type ENUM('window', 'aisle', 'middle') NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES Bus(bus_id),
    UNIQUE (bus_id, seat_number)
);

-- Many-to-Many Relationships (with associative tables)
CREATE TABLE Route (
    route_id INT PRIMARY KEY,
    source VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    distance DECIMAL(10,2) NOT NULL,
    estimated_duration INT NOT NULL,
    type ENUM('express', 'local') NOT NULL
);

CREATE TABLE Driver (
    driver_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    status ENUM('available', 'on_trip', 'off_duty') NOT NULL
);

-- Trip table serves as an associative table for Bus-Driver many-to-many relationship
CREATE TABLE Trip (
    trip_id INT PRIMARY KEY,
    bus_id INT,
    route_id INT,
    driver_id INT,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    status ENUM('scheduled', 'in_progress', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES Bus(bus_id),
    FOREIGN KEY (route_id) REFERENCES Route(route_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

-- Ternary Relationship (Passenger-Trip-Seat)
CREATE TABLE Ticket (
    ticket_id INT PRIMARY KEY,
    passenger_id INT,
    trip_id INT,
    seat_id INT,
    price DECIMAL(10,2) NOT NULL,
    status ENUM('booked', 'cancelled', 'completed') NOT NULL,
    payment_status ENUM('pending', 'completed', 'refunded') NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id),
    UNIQUE (trip_id, seat_id) -- Ensures no double booking
);

-- Maintenance (One-to-Many with Bus)
CREATE TABLE Maintenance (
    maintenance_id INT PRIMARY KEY,
    bus_id INT,
    date DATETIME NOT NULL,
    description TEXT,
    status ENUM('scheduled', 'in_progress', 'completed') NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES Bus(bus_id)
);
