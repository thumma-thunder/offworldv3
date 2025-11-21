-- ============================
-- USER TYPES
-- ============================

CREATE TABLE userType (
    userTypeID SERIAL PRIMARY KEY,
    typeName VARCHAR(30) NOT NULL
);

-- ============================
-- USERS
-- ============================

CREATE TABLE users (
    userID SERIAL PRIMARY KEY,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    userTypeID INT REFERENCES userType(userTypeID)
);

-- ============================
-- COMPANIES
-- ============================

CREATE TABLE company (
    companyID SERIAL PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    companyWebsite VARCHAR(250),
    companyDescription VARCHAR(1000),
    companyCategory VARCHAR(30),
    companyZipcode INT
);

-- ============================
-- STICKER SIZES
-- ============================

CREATE TABLE stickerSize (
    stickerSizeID SERIAL PRIMARY KEY,
    stickerSize VARCHAR(10) NOT NULL
);

-- ============================
-- STICKERS
-- ============================

CREATE TABLE stickers (
    stickerID SERIAL PRIMARY KEY,
    stickerSizeID INT REFERENCES stickerSize(stickerSizeID),
    stickerLogo OID -- PostgreSQL large object (your image)
);

-- ============================
-- USER → STICKERS LINK (many to many)
-- ============================

CREATE TABLE usersToStickers (
    userID INT REFERENCES users(userID),
    stickerID INT REFERENCES stickers(stickerID),
    PRIMARY KEY (userID, stickerID)
);
