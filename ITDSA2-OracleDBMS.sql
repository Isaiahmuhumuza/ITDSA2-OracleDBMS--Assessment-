DROP TABLE USES;
DROP TABLE Activity;
DROP TABLE Rooms;
DROP TABLE Facility;
DROP TABLE Municipality;
DROP TABLE Provinces;

CREATE TABLE Provinces (
    provinceCode NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    provinceName VARCHAR2(100) NOT NULL
);

CREATE TABLE Municipality (
    muniCode NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    muniName VARCHAR2(100) NOT NULL,
    avgPopulation NUMBER NOT NULL,
    fk_provinceCode NUMBER,
    CONSTRAINT fk_provinceCode FOREIGN KEY (fk_provinceCode) REFERENCES Provinces (provinceCode)
);

CREATE TABLE Facility (
    facilityID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    facilityName VARCHAR2(100) NOT NULL,
    capacity NUMBER NOT NULL,
    address VARCHAR2(100) NOT NULL,
    fk_muniCode NUMBER,
    CONSTRAINT fk_muniCode FOREIGN KEY (fk_muniCode) REFERENCES Municipality (muniCode)
);

CREATE TABLE Rooms (
    roomNo NUMBER,
    description VARCHAR2(100) NOT NULL,
    fk_facilityID NUMBER,
    CONSTRAINT pk_Room PRIMARY KEY (roomNo, fk_facilityID),
    CONSTRAINT fk_RoomFacility FOREIGN KEY (fk_facilityID) REFERENCES Facility (facilityID)
);

CREATE TABLE Activity (
    activityRef NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    activityName VARCHAR2(100) NOT NULL
);

CREATE TABLE USES (
    useDate VARCHAR2(100) NOT NULL,
    fk_facilityID NUMBER,
    fk_activityRef NUMBER,
    CONSTRAINT pk_USES PRIMARY KEY (fk_facilityID, fk_activityRef, useDate),
    CONSTRAINT fk_USES_Facility FOREIGN KEY (fk_facilityID) REFERENCES Facility (facilityID),
    CONSTRAINT fk_USES_Activity FOREIGN KEY (fk_activityRef) REFERENCES Activity (activityRef)
);
--Provinces Table
INSERT INTO Provinces (provinceName) VALUES ('Western Cape');
INSERT INTO Provinces (provinceName) VALUES ('North West');
INSERT INTO Provinces (provinceName) VALUES ('Eastern Cape');
INSERT INTO Provinces (provinceName) VALUES ('Northern Cape');
INSERT INTO Provinces (provinceName) VALUES ('Mpumalanga');
INSERT INTO Provinces (provinceName) VALUES ('Gauteng');
INSERT INTO Provinces (provinceName) VALUES ('KwaZulu-Natal');
INSERT INTO Provinces (provinceName) VALUES ('Limpopo');
INSERT INTO Provinces (provinceName) VALUES ('Free State');

--Municipality
INSERT INTO Municipality (muniName, avgPopulation, fk_provinceCode) VALUES ('Cape Town', 4700000, 1);
INSERT INTO Municipality (muniName, avgPopulation, fk_provinceCode) VALUES ('Johannesburg', 6500000, 6);
INSERT INTO Municipality (muniName, avgPopulation, fk_provinceCode) VALUES ('East London', 230000, 3);
INSERT INTO Municipality (muniName, avgPopulation, fk_provinceCode) VALUES ('Pretoria', 7500000, 6);
INSERT INTO Municipality (muniName, avgPopulation, fk_provinceCode) VALUES ('Durban', 2400000, 7);

--Facility
INSERT INTO Facility (facilityName, capacity, address, fk_muniCode) VALUES ('CTICC Building', 500, '1 Lower Long Street', 1);
INSERT INTO Facility (facilityName, capacity, address, fk_muniCode) VALUES ('Johannesburg Expo Centre', 200, 'Corner Rand Show Road', 2);
INSERT INTO Facility (facilityName, capacity, address, fk_muniCode) VALUES ('FNB Stadium', 1000, 'Soccer City Ave', 2);
INSERT INTO Facility (facilityName, capacity, address, fk_muniCode) VALUES ('Resource Centre', 100, '512 Newell Road', 3);
INSERT INTO Facility (facilityName, capacity, address, fk_muniCode) VALUES ('ABQ Ink', 400, 'Reed Boulevard', 4);

--Rooms
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (102, 'Music', 1);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (103, 'Dance', 1);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (101, 'Theatre', 1);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (104, 'Cinema', 1);

INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (102, 'Music', 2);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (101, 'Dance', 2);

INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (101, 'BullFights', 3);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (102, 'Dance', 3);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (103, 'Music', 3);

INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (101, 'Theatre', 4);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (102, 'Dance', 4);

INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (101, 'Circus', 5);
INSERT INTO Rooms (roomNo, description, fk_facilityID) VALUES (102, 'Theatre', 5);

--Activity
INSERT INTO Activity (activityName) VALUES ('IsiZulu dance competition');
INSERT INTO Activity (activityName) VALUES ('Art exhibition');
INSERT INTO Activity (activityName) VALUES ('Movie Night');
INSERT INTO Activity (activityName) VALUES ('Open Mic');
INSERT INTO Activity (activityName) VALUES ('Music Workshop');
INSERT INTO Activity (activityName) VALUES ('Creative Arts and Culture');
INSERT INTO Activity (activityName) VALUES ('Bullfighting');

INSERT INTO USES (useDate, fk_facilityID, fk_activityRef) VALUES ('2024-01-01', 1, 5);
INSERT INTO USES (useDate, fk_facilityID, fk_activityRef) VALUES ('2024-01-02', 2, 4);
INSERT INTO USES (useDate, fk_facilityID, fk_activityRef) VALUES ('2024-01-02', 4, 2);
INSERT INTO USES (useDate, fk_facilityID, fk_activityRef) VALUES ('2024-01-02', 4, 1);
INSERT INTO USES (useDate, fk_facilityID, fk_activityRef) VALUES ('2024-01-02', 5, 4);
-- Question 1.4

SELECT COUNT(*) AS Num_No_Music_Category
FROM Municipality m
WHERE m.muniCode NOT IN (
    SELECT DISTINCT f.fk_muniCode
    FROM Facility f
    JOIN USES u ON f.facilityID = u.fk_facilityID
    JOIN Activity a ON u.fk_activityRef = a.activityRef
    WHERE LOWER(a.activityName) LIKE '%music%');

-- Question 1.5

SELECT provinceCode, provinceName, muniCode, muniName, avgPopulation
FROM Provinces p
LEFT JOIN Municipality m ON m.fk_provinceCode = p.provinceCode
WHERE avgPopulation >= 4000000
ORDER BY p.provinceCode;

-- Question 1.6

CREATE OR REPLACE PROCEDURE Province_Capacity_Utilization_procedure IS
BEGIN
    FOR rec IN (
        SELECT 
            p.provinceName,
            COUNT(f.facilityID) AS total_facilities,
            SUM(f.capacity) AS total_capacity,
    		COUNT(u.fk_facilityID) AS total_activities
        FROM Provinces p
        LEFT JOIN Municipality m ON m.fk_provinceCode = p.provinceCode
        LEFT JOIN Facility f ON f.fk_muniCode = m.muniCode
        LEFT JOIN USES u ON u.fk_facilityID = f.facilityID
        GROUP BY p.provinceName
        ORDER BY total_capacity
    )
    LOOP
        DECLARE
        	utilization_percent NUMBER := 0;
        BEGIN
            IF rec.total_capacity > 0 THEN
                utilization_percent := (rec.total_activities / rec.total_capacity) * 100;
            END IF;
        DBMS_OUTPUT.PUT_LINE('Province: ' || rec.provinceName || ' | Total Facilities: ' || rec.total_facilities || ' | Capacity: ' || rec.total_capacity || ' | Activities: ' || rec.total_activities || ' | Utilization: ' || utilization_percent || '%');
    	END;
	END LOOP;
END;
/
BEGIN
    Province_Capacity_Utilization_procedure;
END;
