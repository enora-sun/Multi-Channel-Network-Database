-- Drop table first here to ensure initialization works
DROP TABLE Influencer CASCADE CONSTRAINTS;
DROP TABLE Platform CASCADE CONSTRAINTS;
DROP TABLE ManagementContractTwo CASCADE CONSTRAINTS;
DROP TABLE SponsorCompany CASCADE CONSTRAINTS;
DROP TABLE PostTwo CASCADE CONSTRAINTS;
DROP TABLE Agency CASCADE CONSTRAINTS;
DROP TABLE BrandDealTwo CASCADE CONSTRAINTS;
DROP TABLE Account CASCADE CONSTRAINTS;
DROP TABLE PostOne CASCADE CONSTRAINTS;
DROP TABLE AccountHoldsPost CASCADE CONSTRAINTS;
DROP TABLE VideoPost CASCADE CONSTRAINTS;
DROP TABLE ImagePost CASCADE CONSTRAINTS;
DROP TABLE TextPost CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE BrandDealOne CASCADE CONSTRAINTS;
DROP TABLE ManagementContractOne CASCADE CONSTRAINTS;
DROP TABLE CollaboratesWith CASCADE CONSTRAINTS;
DROP TABLE Advertise CASCADE CONSTRAINTS;

-- Table creation 

-- Note: the on update cascade clause is not supported;
-- bigint, money, and text are not supported and is changed into their matching type based on 
-- https://docs.oracle.com/en/database/oracle/oracle-database/18/gmswn/database-gateway-sqlserver-data-type-conversion.html 
-- Date format need extra step TO_DATE

CREATE TABLE Influencer (
	influencerID INT PRIMARY KEY,
	influencerName VARCHAR(50),
	location VARCHAR(100),
	age INT,
	niche VARCHAR(50)
);

CREATE TABLE Platform (
	platformName VARCHAR(50) PRIMARY KEY,
	numUsers NUMBER(20)
);

CREATE TABLE ManagementContractTwo (
	influencerPayout FLOAT PRIMARY KEY,
	companyCommission FLOAT
);

CREATE TABLE SponsorCompany (
	companyID INT PRIMARY KEY,
	numEmployees INT
);

CREATE TABLE PostTwo (
	views INT,
	likes INT,
	comments INT,
	engagementRate FLOAT,
	PRIMARY KEY (views, likes, comments)
);

CREATE TABLE Agency (
	agencyID INT PRIMARY KEY,
	establishedDate DATE,
	staffSize INT,
	location VARCHAR(100)
);

CREATE TABLE BrandDealTwo (
	adType VARCHAR(50) PRIMARY KEY,
	paymentType VARCHAR(50)
);

/* 
total participation on Influencer in Influencer-Owns-Account relationship 
cannot be represented without assertions 
*/
CREATE TABLE Account (
	username VARCHAR(100),
	platformName VARCHAR(50),
	influencerID INT,
	followerCount INT,
	activationDate DATE,
	PRIMARY KEY (username, platformName),
	FOREIGN KEY (platformName) REFERENCES Platform(platformName)
		ON DELETE CASCADE,
		-- ON UPDATE CASCADE,
	FOREIGN KEY (influencerID) REFERENCES Influencer(influencerID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);


CREATE TABLE PostOne (
	postID INT PRIMARY KEY,
	timeStamp TIMESTAMP,
	productionCost NUMBER(19,4),
	views INT,
	likes INT,
    comments INT,
	FOREIGN KEY (views, likes, comments) REFERENCES PostTwo(views, likes, comments)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

/* 
total participation on Post in Account-Holds-Post relationship 
cannot be represented without assertions
*/
CREATE TABLE AccountHoldsPost (
	postID INT,
	username VARCHAR(100),
	platformName VARCHAR(50),
	PRIMARY KEY (postID, username, platformName),
	FOREIGN KEY (postID) REFERENCES PostOne(postID)
		ON DELETE CASCADE,
        --ON UPDATE CASCADE,
    FOREIGN KEY (username, platformName) REFERENCES Account(username, platformName)
	    ON DELETE CASCADE
        --ON UPDATE CASCADE
);


CREATE TABLE VideoPost (
	postID INT PRIMARY KEY,
	videoLength FLOAT,
	FOREIGN KEY (postID) REFERENCES PostOne(postID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE ImagePost (
	postID INT PRIMARY KEY,
	picNum INT,
	FOREIGN KEY (postID) REFERENCES PostOne(postID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE TextPost (
	postID INT PRIMARY KEY,
	wordCount INT,
	textContent LONG,
	FOREIGN KEY (postID) REFERENCES PostOne(postID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE Product (
	productName VARCHAR(100),
	companyID INT,
	price NUMBER(19,4),
	category VARCHAR(50),
	PRIMARY KEY (companyID, productName),
	FOREIGN KEY (companyID) REFERENCES SponsorCompany(companyID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE BrandDealOne (
	brandDealID INT PRIMARY KEY,
	adType VARCHAR(50),
	paymentRate NUMBER(19,4),
	companyID INT NOT NULL,
	postID INT NOT NULL UNIQUE,
	FOREIGN KEY (companyID) REFERENCES SponsorCompany(companyID)
		ON DELETE CASCADE,
		--ON UPDATE CASCADE,
	FOREIGN KEY (postID) REFERENCES PostOne(postID)
		ON DELETE CASCADE,
		--ON UPDATE CASCADE,
	FOREIGN KEY (adType) REFERENCES BrandDealTwo(adType)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE ManagementContractOne (
	contractID INT PRIMARY KEY,
	influencerBaseSalary NUMBER(19,4),
	influencerPayout FLOAT,
	influencerID INT NOT NULL,
	agencyID INT NOT NULL,
	FOREIGN KEY (agencyID) REFERENCES Agency(agencyID)
		ON DELETE CASCADE,
		--ON UPDATE CASCADE,
	FOREIGN KEY (influencerID) REFERENCES Influencer(influencerID)
		ON DELETE CASCADE,
		--ON UPDATE CASCADE,
	FOREIGN KEY (influencerPayout) REFERENCES ManagementContractTwo(influencerPayout)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE CollaboratesWith(
	agencyID INT,
	companyID INT,
	numCollaborations INT,
	PRIMARY KEY (agencyID, companyID),
	FOREIGN KEY (agencyID) REFERENCES Agency(agencyID)
		ON DELETE CASCADE,
		--ON UPDATE CASCADE,
	FOREIGN KEY (companyID) REFERENCES SponsorCompany(companyID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);

CREATE TABLE Advertise (
	productName VARCHAR(100),
	companyID INT,
	postID INT,
	PRIMARY KEY (productName, companyID, postID),
	FOREIGN KEY (companyID, productName) REFERENCES Product(companyID, productName)
		ON DELETE CASCADE,
		--ON UPDATE CASCADE,
	FOREIGN KEY (postID) REFERENCES PostOne(postID)
		ON DELETE CASCADE
		--ON UPDATE CASCADE
);


-- Value insertion

INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (1, 'Addison Rae', 'USA', 24, 'Music');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (2, 'Kylie Jenner', 'USA', 27, 'Beauty');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (3, 'Kendall Jenner', 'USA', 29, 'Wine');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (4, 'Kim Kardashian', 'USA', 44, 'TV');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (5, 'Shawn Mendes', 'CAN', 26, 'Music');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (6, 'Justin Bieber', 'CAN', 31, 'Music');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (11, 'Bang Chan', 'AUS', 28, 'Idol');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (12, 'Lee Minho', 'KOR', 27, 'Dance');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (13, 'Seo Changbin', 'KOR', 26, 'Rap');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (14, 'Hwang Hyunjin', 'KOR', 25, 'Dance');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (15, 'Han Jisung', 'MAL', 25, 'Rap');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (16, 'Lee Yongbok', 'AUS', 25, 'Dance');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (17, 'Kim Seungmin', 'KOR', 25, 'Vocal');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (18, 'Yang Jeongin', 'KOR', 24, 'Vocal');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (21, 'Kim Minji', 'BUN', 20, 'Idol');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (22, 'Phan Hanni', 'BUN', 19, 'Idol');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (23, 'Danille Marsh', 'BUN', 18, 'Idol');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (24, 'Kang Haerin', 'BUN', 17, 'Idol');
INSERT INTO Influencer (influencerID, influencerName, location, age, niche) VALUES (25, 'Lee Hyein', 'BUN', 16, 'Idol');

INSERT INTO Platform (platformName, numUsers) VALUES ('Instagram', 1500000000);
INSERT INTO Platform (platformName, numUsers) VALUES ('YouTube', 2500000000);
INSERT INTO Platform (platformName, numUsers) VALUES('TikTok', 1200000000);
INSERT INTO Platform (platformName, numUsers) VALUES ('Facebook', 450000000);
INSERT INTO Platform (platformName, numUsers) VALUES ('Twitter', 500000000);

INSERT INTO ManagementContractTwo (influencerPayout, companyCommission) VALUES (0.70, 0.30);
INSERT INTO ManagementContractTwo (influencerPayout, companyCommission) VALUES (0.75, 0.25);
INSERT INTO ManagementContractTwo (influencerPayout, companyCommission) VALUES (0.80, 0.20);
INSERT INTO ManagementContractTwo (influencerPayout, companyCommission) VALUES (0.85, 0.15);
INSERT INTO ManagementContractTwo (influencerPayout, companyCommission) VALUES (0.90, 0.10);

INSERT INTO SponsorCompany (companyID, numEmployees) VALUES (1, 200);
INSERT INTO SponsorCompany (companyID, numEmployees) VALUES (2, 350);
INSERT INTO SponsorCompany (companyID, numEmployees) VALUES (3, 50);
INSERT INTO SponsorCompany (companyID, numEmployees) VALUES (4, 1200);
INSERT INTO SponsorCompany (companyID, numEmployees) VALUES (5, 75);

INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (24, 4, 1, 0.2083);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (2804, 1000, 15, 0.3620);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (100004, 3894, 1233, 0.0513);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (12, 1, 0, 0.0833);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (9238, 2399, 123, 0.2730);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (502, 120, 15, 0.2689);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (745, 230, 34, 0.3544);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (823, 300, 45, 0.4192);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (1200, 450, 56, 0.4217);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (1350, 520, 62, 0.4311);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (400, 150, 20, 0.4250);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (520, 200, 25, 0.4327);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (600, 250, 30, 0.4667);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (700, 280, 35, 0.4500);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (800, 300, 40, 0.4250);
INSERT INTO PostTwo (views, likes, comments, engagementRate) VALUES (1800, 520, 130, 0.3611);

INSERT INTO Agency (agencyID, establishedDate, staffSize, location) VALUES (1, TO_DATE('2010-05-12', 'yyyy-mm-dd'), 25, 'USA');
INSERT INTO Agency (agencyID, establishedDate, staffSize, location) VALUES (2, TO_DATE('2015-08-20', 'yyyy-mm-dd'), 40, 'USA');
INSERT INTO Agency (agencyID, establishedDate, staffSize, location) VALUES (3, TO_DATE('2008-03-15', 'yyyy-mm-dd'), 15, 'CAN');
INSERT INTO Agency (agencyID, establishedDate, staffSize, location) VALUES (4, TO_DATE('2020-11-01', 'yyyy-mm-dd'), 10, 'CAN');
INSERT INTO Agency (agencyID, establishedDate, staffSize, location) VALUES (5, TO_DATE('2012-07-30', 'yyyy-mm-dd'), 30, 'CAN');

INSERT INTO BrandDealTwo (adType, paymentType) VALUES ('Sponsored Post', 'Flat Fee');
INSERT INTO BrandDealTwo (adType, paymentType) VALUES ('Shoutout', 'Flat Fee');
INSERT INTO BrandDealTwo (adType, paymentType) VALUES ('Giveaway Collaboration', 'Flat Fee');
INSERT INTO BrandDealTwo (adType, paymentType) VALUES ('Review', 'Per View');
INSERT INTO BrandDealTwo (adType, paymentType) VALUES ('Product Placement', 'Per View');

INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('addrae', 'TikTok', 1, 240000, TO_DATE('2025-01-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('addraeins', 'Instagram', 1, 980000, TO_DATE('2025-01-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('addrae', 'YouTube', 1, 240000, TO_DATE('2024-04-15', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('addr', 'Twitter', 1, 9800, TO_DATE('2015-01-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('addraeFacebook', 'Facebook', 1, 100, TO_DATE('2019-02-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('kyljen', 'Instagram', 2, 21700, TO_DATE('2013-07-21', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('jennerxky', 'Twitter', 2, 294000, TO_DATE('2011-07-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('kenjen', 'Instagram', 3, 286000, TO_DATE('2011-07-02', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('kenjen', 'YouTube', 3, 2230, TO_DATE('2015-01-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('kimxkim', 'Twitter', 4, 294000, TO_DATE('2011-07-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('shawn', 'Instagram', 5, 357, TO_DATE('2016-10-09', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('lilbieber', 'Instagram', 6, 294000, TO_DATE('2011-07-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES('justinx', 'Twitter', 6, 294000, TO_DATE('2013-08-01', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('cb1', 'TikTok', 11, 325, TO_DATE('2018-03-25', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('cb2', 'Instagram', 11, 915, TO_DATE('2019-08-06', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('cb3', 'YouTube', 11, 914, TO_DATE('2014-04-25', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('cb4', 'Twitter', 11, 103, TO_DATE('2020-01-03', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('cb5', 'Facebook', 11, 922, TO_DATE('2021-11-20', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('lk1', 'TikTok', 12, 325, TO_DATE('2018-03-25', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('lk2', 'Instagram', 12, 915, TO_DATE('2019-08-06', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('lk3', 'YouTube', 12, 914, TO_DATE('2014-04-25', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate)
VALUES ('lk4', 'Twitter', 12, 103, TO_DATE('2020-01-03', 'yyyy-mm-dd'));
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES ('lk5', 'Facebook', 12, 922, TO_DATE('2021-11-20', 'yyyy-mm-dd'));


INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments) 
VALUES (1,  TO_DATE('2023-10-02 16:24:56', 'YYYY-MM-DD HH24:MI:SS'), 102.30, 24, 4, 1);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (2,  TO_DATE('2023-01-02 06:27:46', 'YYYY-MM-DD HH24:MI:SS'), 302.40, 2804, 1000, 15);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (3,  TO_DATE('2022-02-02 17:24:36', 'YYYY-MM-DD HH24:MI:SS'), 10.00, 100004, 3894, 1233);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (4,  TO_DATE('2020-01-10 11:04:50', 'YYYY-MM-DD HH24:MI:SS'), 1099.00, 12, 1, 0);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (5,  TO_DATE('2023-12-22 19:16:07', 'YYYY-MM-DD HH24:MI:SS'), 80.00, 9238, 2399, 123);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (6,  TO_DATE('2022-06-14 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 150.00, 502, 120, 15);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (7,  TO_DATE('2022-07-01 11:45:20', 'YYYY-MM-DD HH24:MI:SS'), 250.00, 745, 230, 34);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (8,  TO_DATE('2022-08-12 13:15:40', 'YYYY-MM-DD HH24:MI:SS'), 95.00, 823, 300, 45);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (9,  TO_DATE('2022-09-20 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 180.00, 1200, 450, 56);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (10, TO_DATE('2022-10-05 19:30:10', 'YYYY-MM-DD HH24:MI:SS'), 210.00, 1350, 520, 62);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (11, TO_DATE('2022-11-15 12:10:00', 'YYYY-MM-DD HH24:MI:SS'), 70.00, 400, 150, 20);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (12, TO_DATE('2022-12-01 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 85.00, 520, 200, 25);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (13, TO_DATE('2023-01-25 15:35:00', 'YYYY-MM-DD HH24:MI:SS'), 120.00, 600, 250, 30);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (14, TO_DATE('2023-02-10 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), 140.00, 700, 280, 35);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (15, TO_DATE('2023-03-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 160.00, 800, 300, 40);
INSERT INTO PostOne (postID, timeStamp, productionCost, views, likes, comments)
VALUES (16, TO_DATE('2013-03-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2160.00, 1800, 520, 130);

INSERT INTO AccountHoldsPost (postID, username, platformName) 
VALUES (1, 'addrae', 'TikTok');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (2, 'addrae', 'TikTok');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (16, 'addrae', 'TikTok');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (3, 'kyljen', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (4, 'lilbieber', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (5, 'kenjen', 'YouTube');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (6, 'lilbieber', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName) 
VALUES (7, 'addraeins', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (8, 'kenjen', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (9, 'kenjen', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (10, 'kenjen', 'Instagram');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (11, 'justinx', 'Twitter');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (12, 'kimxkim', 'Twitter');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (13, 'justinx', 'Twitter');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (14, 'jennerxky', 'Twitter');
INSERT INTO AccountHoldsPost (postID, username, platformName)
VALUES (15, 'jennerxky', 'Twitter');

INSERT INTO VideoPost (postID, videoLength) VALUES (1, 3.5);
INSERT INTO VideoPost (postID, videoLength) VALUES (2, 10.0);
INSERT INTO VideoPost (postID, videoLength) VALUES (3, 1.2);
INSERT INTO VideoPost (postID, videoLength) VALUES (4, 7.8);
INSERT INTO VideoPost (postID, videoLength) VALUES (5, 5.0);
INSERT INTO VideoPost (postID, videoLength) VALUES (16, 25.0);

INSERT INTO ImagePost (postID, picNum) VALUES (6, 3);
INSERT INTO ImagePost (postID, picNum) VALUES (7, 1);
INSERT INTO ImagePost (postID, picNum) VALUES (8, 5);
INSERT INTO ImagePost (postID, picNum) VALUES (9, 2);
INSERT INTO ImagePost (postID, picNum) VALUES (10, 4);

INSERT INTO TextPost (postID, wordCount, textContent) 
VALUES (11, 120, 'Excited to announce my new partnership!');
INSERT INTO TextPost (postID, wordCount, textContent) 
VALUES (12, 80, 'Check out my latest review of the smartwatch.');
INSERT INTO TextPost (postID, wordCount, textContent) 
VALUES (13, 200, 'Tips on healthy lifestyle and meal prep.');
INSERT INTO TextPost (postID, wordCount, textContent) 
VALUES (14, 150, 'Behind the scenes of my recent campaign.');
INSERT INTO TextPost (postID, wordCount, textContent) 
VALUES (15, 90, 'Thank you all for your support!');

INSERT INTO Product (companyID, productName, price, category) 
VALUES (1, 'Monster Energy Drink', 2.99, 'Beverage');
INSERT INTO Product (companyID, productName, price, category)
VALUES (2, 'Smartwatch Alpha', 199.99, 'Electronics');
INSERT INTO Product (companyID, productName, price, category)
VALUES (3, 'Choco Protein Bar', 1.50, 'Food');
INSERT INTO Product (companyID, productName, price, category)
VALUES (4, 'Silent Keyboard', 79.99, 'Gaming');
INSERT INTO Product (companyID, productName, price, category)
VALUES (5, 'Dove Shampoo', 8.99, 'Personal Care');

INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID) 
VALUES (1, 'Sponsored Post', 500.00, 1, 1);
INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID)
VALUES (2, 'Shoutout', 300.00, 2, 2);
INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID)
VALUES (3, 'Giveaway Collaboration', 750.00, 3, 3);
INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID)
VALUES (4, 'Review', 0.05, 4, 4);
INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID)
VALUES (5, 'Product Placement', 0.10, 5, 16);
INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID)
VALUES (6, 'Review', 0.3, 1, 13);
INSERT INTO BrandDealOne (brandDealID, adType, paymentRate, companyID, postID)
VALUES (7, 'Shoutout', 100, 1, 15);

INSERT INTO ManagementContractOne (contractID, influencerBaseSalary, influencerPayout, influencerID, agencyID) 
VALUES (1, 50000.00, 0.70, 4, 1);
INSERT INTO ManagementContractOne (contractID, influencerBaseSalary, influencerPayout, influencerID, agencyID) 
VALUES (2, 60000.00, 0.75, 5, 2);
INSERT INTO ManagementContractOne (contractID, influencerBaseSalary, influencerPayout, influencerID, agencyID) 
VALUES (3, 55000.00, 0.80, 3, 3);
INSERT INTO ManagementContractOne (contractID, influencerBaseSalary, influencerPayout, influencerID, agencyID) 
VALUES (4, 70000.00, 0.85, 1, 4);
INSERT INTO ManagementContractOne (contractID, influencerBaseSalary, influencerPayout, influencerID, agencyID) 
VALUES (5, 65000.00, 0.90, 2, 5);


INSERT INTO CollaboratesWith(agencyID, companyID, numCollaborations) VALUES (1, 1, 5);
INSERT INTO CollaboratesWith(agencyID, companyID, numCollaborations) VALUES (1, 2, 3);
INSERT INTO CollaboratesWith(agencyID, companyID, numCollaborations) VALUES (2, 3, 4);
INSERT INTO CollaboratesWith(agencyID, companyID, numCollaborations) VALUES (3, 4, 2);
INSERT INTO CollaboratesWith(agencyID, companyID, numCollaborations) VALUES (4, 5, 6);

INSERT INTO Advertise (productName, companyID, postID) VALUES ('Monster Energy Drink', 1, 6);
INSERT INTO Advertise (productName, companyID, postID) VALUES ('Smartwatch Alpha', 2, 2);
INSERT INTO Advertise (productName, companyID, postID) VALUES ('Choco Protein Bar', 3, 11);
INSERT INTO Advertise (productName, companyID, postID) VALUES ('Silent Keyboard', 4, 1);
INSERT INTO Advertise (productName, companyID, postID) VALUES('Dove Shampoo', 5, 16);


