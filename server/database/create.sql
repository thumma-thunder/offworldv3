CREATE TABLE userType(
    userTypeID SERIAL PRIMARY KEY,
    typeName varchar(1)
);

CREATE TABLE users(
    userID SERIAL PRIMARY KEY,
    username varchar(30),
    userTypeID INT,
    password varchar(255),
    userTypeID references userType(userTypeID)
);

CREATE TABLE stickerSize(
    stickerSizeID SERIAL PRIMARY KEY,
    stickerSize varchar(1)
);

CREATE TABLE stickers(
    stickerID SERIAL PRIMARY KEY,
    stickerSizeID varchar(1),
    stickerLogo OID,
    stickerSizeID references stickerSize(stickerSizeID)
);

CREATE TABLE usersToStickers(
    stickerID INT,
    userID INT,
    PRIMARY KEY (stickerID, userID),
    FOREIGN KEY (stickerID) references stickers(stickerID),
    FOREIGN KEY (userID) references users(userID)
);