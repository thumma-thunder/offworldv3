CREATE TABLE userType(
    userTypeID SERIAL PRIMARY KEY,
    typeName varchar(1)
);

CREATE TABLE users(
    userID SERIAL PRIMARY KEY,
    username varchar(30),
    userTypeID INT,
    userTypeID references userType(userTypeID),
    password varchar(255)
);

-- talk to noah about making a set number of categories
CREATE TABLE company(
    companyID SERIAL PRIMARY KEY,
    companyName varchar(100),
    companyWebsite varchar(250),
    companyDescription varchar(1000),
    companyCategory varchar(30)
);

CREATE TABLE stickerSize(
    stickerSizeID SERIAL PRIMARY KEY,
    stickerSize varchar(1)
);

CREATE TABLE stickers(
    stickerID SERIAL PRIMARY KEY,
    stickerSizeID varchar(1),
    stickerSizeID references stickerSize(sti)
    stickerLogo OID,
);

CREATE TABLE usersToStickers(
    stickerID INT,
    userID INT
);