/*
 * These functions below are for various webpage functionalities. 
 * Each function serves to process data on the frontend:
 *      - Before sending requests to the backend.
 *      - After receiving responses from the backend.
 * 
 * To tailor them to your specific needs,
 * adjust or expand these functions to match both your 
 *   backend endpoints 
 * and 
 *   HTML structure.
 * 
 */


// This function checks the database connection and updates its status on the frontend.
async function checkDbConnection() {
    const statusElem = document.getElementById('dbStatus');
    const loadingGifElem = document.getElementById('loadingGif');

    const response = await fetch('/check-db-connection', {
        method: "GET"
    });

    // Hide the loading GIF once the response is received.
    loadingGifElem.style.display = 'none';
    // Display the statusElem's text in the placeholder.
    statusElem.style.display = 'inline';

    response.text()
        .then((text) => {
            statusElem.textContent = text;
        })
        .catch((error) => {
            statusElem.textContent = 'connection timed out';  // Adjust error handling if required.
        });
}

// Fetches data from the Account and displays it.
async function fetchAndDisplayAccounts() {

    const tableElement = document.getElementById('Account');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/account', {
        method: 'GET'
    });

    const responseData = await response.json();
    const accountContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    accountContent.forEach(account => {
        const row = tableBody.insertRow();
        account.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// fetch from Influencer and display it
async function fetchAndDisplayInfluencers() {

    const tableElement = document.getElementById('Influencer');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/influencer', {
        method: 'GET'
    });

    const responseData = await response.json();
    const influencerContent = responseData.data;

    if (tableBody) {
        tableBody.innerHTML = '';
    }

    influencerContent.forEach(influencer => {
        const row = tableBody.insertRow();
        influencer.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// Fetches data from BrandDealOne and displays it.
async function fetchAndDisplayBrandDeals() {

    const tableElement = document.getElementById('BrandDeal');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/brandDeal', {
        method: 'GET'
    });

    const responseData = await response.json();
    const brandDealContent = responseData.data;

    if (tableBody) {
        tableBody.innerHTML = '';
    }

    brandDealContent.forEach(deal => {
        const row = tableBody.insertRow();
        deal.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// Fetches data from BrandDealOne and displays it as dropdown options.
async function fetchAndDisplayBrandDealOptions() {

    const dropdown = document.getElementById('brandDealIDs');

    try {
        const response = await fetch('/brandDeal', {
            method: 'GET'
        });

        const responseData = await response.json();
        const brandDealContent = responseData.data;

        if (dropdown) {
            dropdown.innerHTML = '';
        }

        // default/placeholder option
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Select an ID';
        dropdown.appendChild(defaultOption);

        brandDealContent.forEach(bd => {
            const option = document.createElement('option');
            option.value = bd[0];
            option.textContent = bd[0];
            dropdown.appendChild(option);
        });
    } catch (error) {
        console.error('Failed to fetch brand deal data:', error);
    }
}

// Fetches data from SponsorCompany and displays it as dropdown options.
async function fetchAndDisplayCompanyOptions() {

    const dropdown = document.getElementById('companyIDs');

    try {
        const response = await fetch('/company', {
            method: 'GET'
        });

        const responseData = await response.json();
        const companyContent = responseData.data;

        if (dropdown) {
            dropdown.innerHTML = '';
        }

        // default/placeholder option
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Select an ID';
        dropdown.appendChild(defaultOption);

        companyContent.forEach(company => {
            const option = document.createElement('option');
            option.value = company[0];
            option.textContent = company[0];
            dropdown.appendChild(option);
        });
    } catch (error) {
        console.error('Failed to fetch company data:', error);
    }
}

// Fetches data from PostOne and displays it as dropdown options.
async function fetchAndDisplayPostOptions() {

    const dropdown = document.getElementById('postIDs');

    try {
        const response = await fetch('/post', {
            method: 'GET'
        });

        const responseData = await response.json();
        const postContent = responseData.data;

        if (dropdown) {
            dropdown.innerHTML = '';
        }

        // default/placeholder option
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Select an ID';
        dropdown.appendChild(defaultOption);

        postContent.forEach(post => {
            const option = document.createElement('option');
            option.value = post[0];
            option.textContent = post[0];
            dropdown.appendChild(option);
        });
    } catch (error) {
        console.error('Failed to fetch post data:', error);
    }
}

// Inserts new records into the Account.
async function insertAccount(event) {
    event.preventDefault();

    const usernameVal = document.getElementById('insertUsername').value;
    const platformVal = document.getElementById('insertPlatform').value;
    const influencerIDVal = document.getElementById('insertInfluencerID').value;
    const followersVal = document.getElementById('insertFollowerCount').value;
    const activationDateVal = document.getElementById('insertActDate').value;

    const response = await fetch('/insert-account', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            username: usernameVal,
            platform: platformVal,
            influencer: influencerIDVal,
            followers: followersVal,
            date: activationDateVal
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('insertResultMsg');

    if (responseData.success) {
        messageElement.textContent = "Data inserted successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error inserting data!";
    }
}

async function deleteInfluencer(event) {
    event.preventDefault();
    const influencerID = document.getElementById('deleteID').value;

    const response = await fetch(`/delete-influencer/${influencerID}`, {
        method: 'DELETE'
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('deleteResultMessage');
    messageElement.style.visibility = "visible";
    if (responseData.success) {
        messageElement.textContent = "Data deleted successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = `Error: ${responseData.message}`;
    }

    setTimeout(() => {
        messageElement.style.visibility = "hidden";
    }, 3000)
}

async function updateBrandDeal(event) {
    event.preventDefault();

    const brandDealIDValue = document.getElementById('brandDealIDs').value;
    const adTypeValue = document.getElementById('adTypes').value;
    const paymentRateValue = document.getElementById('paymentRate').value;
    const companyIDValue = document.getElementById('companyIDs').value;
    const postIDValue = document.getElementById('postIDs').value;

    const response = await fetch('/update-brandDeal', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            brandDealID: brandDealIDValue,
            adType: adTypeValue,
            paymentRate: paymentRateValue,
            companyID: companyIDValue,
            postID: postIDValue,
        })
    });
    
    const responseData = await response.json();
    const messageElement = document.getElementById('updateResultMessage');
    
    if (responseData.success) {
        messageElement.textContent = "Brand deal updated successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error updating brand deal!";
    }
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function () {
    checkDbConnection();
    fetchTableData();
    document.getElementById("insertAccount").addEventListener("submit", insertAccount);
    document.getElementById("deleteInfluencer").addEventListener("submit", deleteInfluencer);
    document.getElementById("updateBrandDeal").addEventListener("submit", updateBrandDeal);;
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayAccounts();
    fetchAndDisplayInfluencers();
    fetchAndDisplayBrandDeals();
    fetchAndDisplayCompanyOptions();
    fetchAndDisplayPostOptions();
    fetchAndDisplayBrandDealOptions(); 
}
