CREATE TABLE userType(
    userTypeID SERIAL PRIMARY KEY,
    typeName varchar(1)
);

CREATE TABLE users(
    userID SERIAL PRIMARY KEY,
    username varchar(30),
    userTypeID INT,
    password varchar(255)
);

CREATE TABLE stickerSize(
    stickerSizeID SERIAL PRIMARY KEY,
    stickerSize varchar(1)
);

CREATE TABLE stickers(
    stickerID SERIAL PRIMARY KEY,
    stickerSizeID varchar(1),
    stickerLogo OID,
);

CREATE TABLE usersToStickers(
    stickerID INT,
    userID INT
);