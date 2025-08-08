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

async function joinTables(event) {
    event.preventDefault();
    const costInputElement = document.getElementById("costThreshold");
    const costThreshold = costInputElement.value;

    const response = await fetch(`/join-table/${costThreshold}`, {
        method: 'GET'
    });

    const responseData = await response.json();
    const joinTable = responseData.data;
    const messageElement = document.getElementById('joinResultMessage');
    messageElement.style.visibility = "visible";
    if (responseData.success) {
        if (joinTable && joinTable.length > 0) {
            messageElement.textContent = "Data successfully displayed!";
        } else {
            messageElement.textContent = "No results found.";
        }
    } else {
        messageElement.textContent = `Error: ${responseData.message || "Unable to display data."}`;
    }

    setTimeout(() => {
        messageElement.style.visibility = "hidden";
    }, 3000);
    
    const tableHeaderElement = document.getElementById("joinTable");
    tableHeaderElement.style.visibility = "visible";

    const tableElement = document.getElementById('joinTable');
    const tableBody = tableElement.querySelector('tbody');
    tableBody.innerHTML = '';

    joinTable.forEach(item => {
        const row = tableBody.insertRow();
        item.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

async function aggregationWithHaving(event) {
    event.preventDefault();
    const engagementInput = document.getElementById("engagementRateInput").value;

    const response = await fetch(`/aggregation-with-having?engagementRate=${engagementInput}`, {
        method: 'GET'
    });

    const responseTable = await response.json();
    const aggregationTable = responseTable.data;

    const messageElement = document.getElementById('aggHavingResultMessage');
    messageElement.style.visibility = "visible";
    if (responseTable.success) {
        if (aggregationTable && aggregationTable.length > 0) {
            messageElement.textContent = "Data successfully displayed!";
        } else {
            messageElement.textContent = "No results found.";
        }
    } else {
        messageElement.textContent = `Error: ${responseTable.message || "Unable to display data."}`;
    }

    setTimeout(() => {
        messageElement.style.visibility = "hidden";
    }, 3000);
    
    const tableElement = document.getElementById("aggWithHavingTable");
    tableElement.style.visibility = "visible";

    const tableBody = tableElement.querySelector('tbody');
    tableBody.innerHTML = '';

    aggregationTable.forEach(item => {
        const row = tableBody.insertRow();
        item.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

async function nestedAggregation(event) {
    event.preventDefault();

    const response = await fetch('/nested-aggregation', {
        method: 'GET'
    });

    const responseTable = await response.json();
    const aggregationTable = responseTable.data;

    const messageElement = document.getElementById('nestedAggResultMessage');
    messageElement.style.visibility = "visible";
    if (responseTable.success) {
        if (aggregationTable && aggregationTable.length > 0) {
            messageElement.textContent = "Data successfully displayed!";
        } else {
            messageElement.textContent = "No results found.";
        }
    } else {
        messageElement.textContent = `Error: ${responseTable.message || "Unable to display data."}`;
    }

    setTimeout(() => {
        messageElement.style.visibility = "hidden";
    }, 3000);
    
    const tableElement = document.getElementById("nestedAggTable");
    tableElement.style.visibility = "visible";

    const tableBody = tableElement.querySelector('tbody');
    tableBody.innerHTML = '';

    aggregationTable.forEach(item => {
        const row = tableBody.insertRow();
        item.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

async function groupByAggregation(event) {
    event.preventDefault();

    const response = await fetch('/group-by-aggregation', {
        method: 'GET'
    });

    const responseTable = await response.json();
    const aggregationTable = responseTable.data;
    const messageElement = document.getElementById('groupByAggResultMessage');
    messageElement.style.visibility = "visible";
    if (responseTable.success) {
        if (aggregationTable && aggregationTable.length > 0) {
            messageElement.textContent = "Data successfully displayed!";
        } else {
            messageElement.textContent = "No results found.";
        }
    } else {
        messageElement.textContent = `Error: ${responseTable.message || "Unable to display data."}`;
    }

    setTimeout(() => {
        messageElement.style.visibility = "hidden";
    }, 3000);
    
    const tableElement = document.getElementById("groupByAggTable");
    tableElement.style.visibility = "visible";

    const tableBody = tableElement.querySelector('tbody');
    tableBody.innerHTML = '';

    aggregationTable.forEach(item => {
        const row = tableBody.insertRow();
        item.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

async function divisionAgg(event) {
    event.preventDefault();
    const response = await fetch('/division-aggregation', {
        method: 'GET'
    });
    const responseTable = await response.json();
    const aggregationTable = responseTable.data;

    const messageElement = document.getElementById('divideAggResultMessage');
    messageElement.style.visibility = "visible";
    if (responseTable.success) {
        if (aggregationTable && aggregationTable.length > 0) {
            messageElement.textContent = "Data successfully displayed!";
        } else {
            messageElement.textContent = "No results found.";
        }
    } else {
        messageElement.textContent = `Error: ${responseTable.message || "Unable to display data."}`;
    }

    setTimeout(() => {
        messageElement.style.visibility = "hidden";
    }, 3000);

    const tableElement = document.getElementById("divisionTable");
    tableElement.style.visibility = "visible";
    const tableBody = tableElement.querySelector('tbody');
    tableBody.innerHTML = '';
    aggregationTable.forEach(item => {
        const row = tableBody.insertRow();
        item.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function () {
    checkDbConnection();    
    document.getElementById("joinQuery").addEventListener("submit", joinTables);
    document.getElementById("aggregationWithHaving").addEventListener("submit", aggregationWithHaving);
    document.getElementById("nestedAggBtn").addEventListener("click", nestedAggregation);
    document.getElementById("groupByAggBtn").addEventListener("click", groupByAggregation);
    document.getElementById("divisionBtn").addEventListener("click", divisionAgg);
    document.getElementById("joinQuery").addEventListener("submit", joinTables);
};
