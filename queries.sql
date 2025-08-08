/* this file is not for running purpose, but to list all the query here for a clear view */

-- INSERT Operation
-- SQL query:
INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
VALUES (:username, :platform, :influencer, :followers, TO_DATE(:actDate, 'yyyy-mm-dd'));
-- Code Position:
-- appService.js line 149-150

-- DELETE Operation
-- SQL query:
DELETE FROM Influencer WHERE influencerID = :deleteID
-- Code Position:
-- appService.js line 126

-- UPDATE Operation
-- SQL query:
UPDATE BrandDealOne SET adType=:adType, paymentRate=:paymentRate, companyID=:companyID, postID=:postID WHERE brandDealID=:brandDealID
-- Code Position:
-- appService.js line 164

-- Selection AND
-- SQL query:
SELECT * FROM Influencer WHERE ${whereClauses.join(' ')}
-- Code Position:
-- appService.js line 194

-- Selection OR
-- SQL query:
SELECT * FROM Influencer WHERE ${whereClauses.join(' ')}
-- Code Position:
-- appService.js line 255

-- Projection
-- SQL query:
SELECT table_name FROM user_tables
SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name =:tableName
SELECT ${attributes} FROM ${tableName}
-- Code Position:
-- appService.js line 206, 216, 228 

-- Join 
-- Find the advertisement type of a post whose production cost is above certain threshold
-- SQL query:
SELECT BrandDealOne.adType, PostOne.productionCost
             FROM BrandDealOne, PostOne
             WHERE BrandDealOne.postID = PostOne.postID AND PostOne.productionCost > :productionCost
-- Code Position:
-- appService.js line 268-270

-- Aggregation with group by
-- Find the average age of influencers on each platform
-- SQL query:
SELECT A.platformName, AVG(I.age)
                FROM Influencer I, Account A
                WHERE I.influencerID = A.influencerID
                GROUP BY A.platformName
-- Code Position:
-- appService.js line 283-286

-- Aggregation with having
-- Find the average post engagement rate for each category of advertised product with engagement rates above the lower bound
-- SQL query:
SELECT PR.category, AVG((P.likes + P.comments)/CAST(P.views AS FLOAT)) AS avgEngagementRate
             FROM PostOne P, Advertise A, Product PR
             WHERE P.postID = A.postID AND A.productName = PR.productName AND A.companyID = PR.companyID AND P.views > 0
             GROUP BY PR.category
             HAVING AVG((P.likes + P.comments)/CAST(P.views AS FLOAT)) > :engagementRate

-- Code Position:
-- appService.js line 297-301 

-- Nested aggregation with group by
-- Find the account that has made the most sponsored posts under brand deals
-- SQL query:
CREATE OR REPLACE VIEW NumBDsPerAccount(username, platform, numBDs) as 
                SELECT A.username, A.platformName, COUNT(B.brandDealID) AS numBDs
                FROM BrandDealOne B, PostOne P, AccountHoldsPost A
                WHERE B.postID = P.postID AND P.postID = A.postID
                GROUP BY A.username, A.platformName


SELECT *
             FROM NumBDsPerAccount N
             WHERE N.numBDs = (SELECT MAX(numBDs) FROM NumBDsPerAccount)

-- Code Position:
-- appService.js line 313-317, 320-322

-- Division 
-- Find all IDs of influencers who have accounts on every platform
-- SQL query:
CREATE OR REPLACE VIEW influencerAccount (influencerID, username, platformName) as
                SELECT I.influencerID, A.username, A.platformName
                FROM Influencer I, Account A
                Where I.influencerID = A. influencerID

SELECT influencerID
                FROM influencerAccount
                GROUP BY influencerID 
                HAVING COUNT (DISTINCT platformName) = (SELECT COUNT (*)
                FROM Platform)
-- Code Position:
-- appService.js line 333-336, 339-343

