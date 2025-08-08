const oracledb = require('oracledb');
const loadEnvFile = require('./utils/envUtil');

const envVariables = loadEnvFile('./.env');

// Database configuration setup. Ensure your .env file has the required database credentials.
const dbConfig = {
    user: envVariables.ORACLE_USER,
    password: envVariables.ORACLE_PASS,
    connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
    poolMin: 1,
    poolMax: 3,
    poolIncrement: 1,
    poolTimeout: 60
};

// initialize connection pool
async function initializeConnectionPool() {
    try {
        await oracledb.createPool(dbConfig);
        console.log('Connection pool started');
    } catch (err) {
        console.error('Initialization error: ' + err.message);
    }
}

async function closePoolAndExit() {
    console.log('\nTerminating');
    try {
        await oracledb.getPool().close(10); // 10 seconds grace period for connections to finish
        console.log('Pool closed');
        process.exit(0);
    } catch (err) {
        console.error(err.message);
        process.exit(1);
    }
}

initializeConnectionPool();

process
    .once('SIGTERM', closePoolAndExit)
    .once('SIGINT', closePoolAndExit);


// ----------------------------------------------------------
// Wrapper to manage OracleDB actions, simplifying connection handling.
async function withOracleDB(action) {
    let connection;
    try {
        connection = await oracledb.getConnection(); // Gets a connection from the default pool 
        return await action(connection);
    } catch (err) {
        console.error(err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}


// ----------------------------------------------------------
// Core functions for database operations
async function testOracleConnection() {
    return await withOracleDB(async (connection) => {
        return true;
    }).catch(() => {
        return false;
    });
}

async function fetchAccountFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM Account ORDER BY influencerID ASC, username ASC');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchInfluencerFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM Influencer ORDER BY influencerID ASC');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchBrandDealFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM BrandDealOne ORDER BY brandDealID ASC');
        return result.rows;
    }).catch(() => {
        return [];
    })
}

async function fetchCompanyFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM SponsorCompany');
        return result.rows;
    }).catch(() => {
        return [];
    })
}

async function fetchPostFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM PostOne');
        return result.rows;
    }).catch(() => {
        return [];
    })
}

async function deleteInfluencer(deleteID) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            'DELETE FROM Influencer WHERE influencerID = :deleteID ',
            [deleteID],
            { autoCommit: true }
        );

        if (result.rowsAffected == 0) {
            return {
                success: false,
                message: `Cannot delete the influencer with ID ${deleteID}.
                Please re-check if the ID entered is valid or not.`
            };
        }
        return { success: true, message: null };

    }).catch((error) => {
        jsonResult = { success: false, message: error.message };
        return jsonResult;
    });
}

async function insertAccount(username, platform, influencer, followers, actDate) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO Account (username, platformName, influencerID, followerCount, activationDate) 
            VALUES (:username, :platform, :influencer, :followers, TO_DATE(:actDate, 'yyyy-mm-dd'))`,
            [username, platform, influencer, followers, actDate],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function updateBrandDeal(brandDealID, adType, paymentRate, companyID, postID) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            'UPDATE BrandDealOne SET adType=:adType, paymentRate=:paymentRate, companyID=:companyID, postID=:postID WHERE brandDealID=:brandDealID',
            [adType, paymentRate, companyID, postID, brandDealID],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function filterInfluencer(filters) {
    return await withOracleDB(async (connection) => {
        const whereClauses = [];
        const bindValues = {};
        filters.forEach((f, index) => {
            const key = `vals${index}`;
            const clause = f.op === 'LIKE'
                ? `${f.attr} LIKE :${key}`
                : `${f.attr} ${f.op} :${key}`;
            bindValues[key] = ['age', 'influencerID'].includes(f.attr)
                ? Number(f.val)
                : (f.op === 'LIKE' ? `%${f.val}%` : f.val);
            if (index === 0) {
                whereClauses.push(clause);
            } else {
                const conj = f.conj?.toUpperCase() === 'OR' ? 'OR' : 'AND';
                whereClauses.push(`${conj} ${clause}`);
            }
        });
        const query = `SELECT * FROM Influencer WHERE ${whereClauses.join(' ')}`;
        console.log("Query:", query);
        console.log("Bind values:", bindValues);
        const result = await connection.execute(query, bindValues);
        return result.rows;
    }).catch((err) => {
        console.error(err)
    });
}

async function fetchTableNamesFromDB() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT table_name FROM user_tables');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchAttributeNameFromTable(tableName) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            'SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name =:tableName',
            [tableName]
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchProjectionTableFromDB(tableName, attributes) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `SELECT ${attributes} FROM ${tableName}`
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function filterInfluencerOr(filters) {
    return await withOracleDB(async (connection) => {
        const whereClauses = [];
        const bindValues = {};
        filters.forEach((f, index) => {
            const key = `vals${index}`;
            const clause = f.op === 'LIKE'
                ? `${f.attr} LIKE :${key}`
                : `${f.attr} ${f.op} :${key}`;
            bindValues[key] = ['age', 'influencerID'].includes(f.attr)
                ? Number(f.val)
                : (f.op === 'LIKE' ? `%${f.val}%` : f.val);
            if (index === 0) {
                whereClauses.push(clause);
            } else {
                const conj = f.conj?.toUpperCase() === 'OR' ? 'OR' : 'OR';
                whereClauses.push(`${conj} ${clause}`);
            }
        });
        const query = `SELECT * FROM Influencer WHERE ${whereClauses.join(' ')}`;
        console.log("Query:", query);
        console.log("Bind values:", bindValues);
        const result = await connection.execute(query, bindValues);
        return result.rows;
    }).catch((err) => {
        console.error(err)
    });
}

async function fetchJoinedTable(productionCost) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `SELECT BrandDealOne.adType, PostOne.productionCost
             FROM BrandDealOne, PostOne
             WHERE BrandDealOne.postID = PostOne.postID AND PostOne.productionCost > :productionCost`,
             [productionCost]
        );
        return result.rows;
    }).catch(() => {

        return [];
    });
}

async function fetchGroupByAggTable() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `SELECT A.platformName, AVG(I.age)
                FROM Influencer I, Account A
                WHERE I.influencerID = A.influencerID
                GROUP BY A.platformName`
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchAggWithHavingTable(engagementRate) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `SELECT PR.category, AVG((P.likes + P.comments)/CAST(P.views AS FLOAT)) AS avgEngagementRate
             FROM PostOne P, Advertise A, Product PR
             WHERE P.postID = A.postID AND A.productName = PR.productName AND A.companyID = PR.companyID AND P.views > 0
             GROUP BY PR.category
             HAVING AVG((P.likes + P.comments)/CAST(P.views AS FLOAT)) > :engagementRate`,
            [engagementRate]
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchNestedAggTable() {
    return await withOracleDB(async (connection) => {
        await connection.execute(
            `CREATE OR REPLACE VIEW NumBDsPerAccount(username, platform, numBDs) as 
                SELECT A.username, A.platformName, COUNT(B.brandDealID) AS numBDs
                FROM BrandDealOne B, PostOne P, AccountHoldsPost A
                WHERE B.postID = P.postID AND P.postID = A.postID
                GROUP BY A.username, A.platformName`
        );
        const result = await connection.execute(
            `SELECT *
             FROM NumBDsPerAccount N
             WHERE N.numBDs = (SELECT MAX(numBDs) FROM NumBDsPerAccount)`
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchDivisionTable() {
    return await withOracleDB(async (connection) => {
        await connection.execute(
            `CREATE OR REPLACE VIEW influencerAccount (influencerID, username, platformName) as
                SELECT I.influencerID, A.username, A.platformName
                FROM Influencer I, Account A
                WHERE I.influencerID = A.influencerID`
        );
        const result = await connection.execute(
            `SELECT influencerID
                FROM influencerAccount
                GROUP BY influencerID 
                HAVING COUNT (DISTINCT platformName) = (SELECT COUNT (*)
                FROM Platform)`
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

module.exports = {
    testOracleConnection,
    fetchAccountFromDb,
    fetchInfluencerFromDb,
    fetchBrandDealFromDb,
    fetchCompanyFromDb,
    fetchPostFromDb,
    deleteInfluencer,
    fetchTableNamesFromDB,
    fetchAttributeNameFromTable,
    fetchProjectionTableFromDB,
    fetchJoinedTable,
    insertAccount,
    insertAccount,
    updateBrandDeal,
    filterInfluencer,
    filterInfluencerOr,
    fetchAggWithHavingTable,
    fetchNestedAggTable,
    fetchGroupByAggTable,
    fetchDivisionTable
};