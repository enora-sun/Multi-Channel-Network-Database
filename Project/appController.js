const express = require('express');
const appService = require('./appService');

const router = express.Router();

// ----------------------------------------------------------
// API endpoints

router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    if (isConnect) {
        res.send('connected');
    } else {
        res.send('unable to connect');
    }
});

router.get('/account', async (req, res) => {
    const tableContent = await appService.fetchAccountFromDb();
    res.json({data: tableContent});
});

router.get('/influencer', async (req, res) => {
    const tableContent = await appService.fetchInfluencerFromDb();
    res.json({data: tableContent});
});

router.get('/brandDeal', async (req, res) => {
    const tableContent = await appService.fetchBrandDealFromDb();
    res.json({data: tableContent});
});

router.get('/company', async (req, res) => {
    const tableContent = await appService.fetchCompanyFromDb();
    res.json({data: tableContent});
});

router.get('/post', async (req, res) => {
    const tableContent = await appService.fetchPostFromDb();
    res.json({data: tableContent});
});

router.get("/table-names", async(req, res) => {
    const tableNames = await appService.fetchTableNamesFromDB();
    res.json({data: tableNames});
});

router.get("/table-attributes/:tbname", async(req, res) => {
    const attributes = await appService.fetchAttributeNameFromTable(req.params.tbname);
    res.json({data: attributes});
});

router.get("/projection-table/:tbname/:attributes", async(req, res) => {
    const prjTable = await appService.fetchProjectionTableFromDB(
        req.params.tbname, 
        req.params.attributes
    );
    res.json({
        success: true,
        data: prjTable});

});

router.get("/join-table/:cost", async(req, res) => {
    const joinTable = await appService.fetchJoinedTable(
        req.params.cost
    );
    res.json({
        success: true,
        data: joinTable});
});

router.delete('/delete-influencer/:id', async (req, res) => {
    const deleteResult = await appService.deleteInfluencer(req.params.id);
    res.json(deleteResult);
});

router.post("/insert-account", async (req, res) => {
    const {username, platform, influencer, followers, date} = req.body;
    const insertResult = await appService.insertAccount(
        username, platform, influencer, followers, date
    );
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/update-brandDeal", async (req, res) => {
    const { brandDealID, adType, paymentRate, companyID, postID } = req.body;
    const updateResult = await appService.updateBrandDeal(brandDealID, adType, paymentRate, companyID, postID);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post('/filter-influencer', async(req, res)=>{
    const result=await appService.filterInfluencer(req.body.filters);
    res.json({
        success: true,
        data:result});
});

router.post('/filter-influencer-or', async (req, res) => {
    const result = await appService.filterInfluencerOr(req.body.filters);
    res.json({ 
        success: true,
        data: result });
});

router.get('/group-by-aggregation', async (req, res) => {
    const tableContent = await appService.fetchGroupByAggTable();
    res.json({ 
        success: true,
        data: tableContent });
});

router.get('/aggregation-with-having', async (req, res) => {
    const tableContent = await appService.fetchAggWithHavingTable(
        req.query.engagementRate
    );
    res.json({
        success: true,
        data: tableContent});
});

router.get('/nested-aggregation', async (req, res) => {
    const tableContent = await appService.fetchNestedAggTable();
    res.json({ 
        success: true,
        data: tableContent });
});

router.get('/division-aggregation', async (req, res) => {
    const tableContent = await appService.fetchDivisionTable();
    res.json({ 
        success: true,
        data: tableContent });
});

module.exports = router;