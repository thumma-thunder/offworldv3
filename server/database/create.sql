CREATE DATABASE Offworld;
\c Offworld

CREATE TABLE userType(
    userTypeID SERIAL PRIMARY KEY,
    typeName varchar(50)  -- Increased size for type names
);

CREATE TABLE users(
    userID SERIAL PRIMARY KEY,
    username varchar(30),
    password varchar(255),
    userTypeID INT,
    FOREIGN KEY (userTypeID) REFERENCES userType(userTypeID)
);

CREATE TABLE stickerSize(
    stickerSizeID SERIAL PRIMARY KEY,
    stickerSize varchar(20)  -- Increased size (e.g., "small", "medium", "large")
);

CREATE TABLE stickers(
    stickerID SERIAL PRIMARY KEY,
    stickerSizeID INT,  -- Changed to INT
    stickerLogo BYTEA,  -- Changed from OID to BYTEA
    FOREIGN KEY (stickerSizeID) REFERENCES stickerSize(stickerSizeID)
);

CREATE TABLE usersToStickers(
    stickerID INT,
    userID INT,
    PRIMARY KEY (stickerID, userID),
    FOREIGN KEY (stickerID) REFERENCES stickers(stickerID),
    FOREIGN KEY (userID) REFERENCES users(userID)
);