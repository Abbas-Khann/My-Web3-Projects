console.log('Hey Moralis');

// https://67xfhomgdd1d.usemoralis.com:2053/server

// 0fVFiVsvuAS7TFYAd3SBXF74jFsNx0teE8mvcC6H

// connect to Moralis server

const serverUrl = "https://67xfhomgdd1d.usemoralis.com:2053/server";
const appId = "0fVFiVsvuAS7TFYAd3SBXF74jFsNx0teE8mvcC6H";
Moralis.start({ serverUrl, appId });
let homepage = "http://127.0.0.1:5500/index.html";

if(Moralis.User.current() == null && window.location.href != homepage) {
    document.querySelector('body').style.display = 'none';
    window.location.href = "index.html";
}

login = async () => {
    await Moralis.Web3.authenticate().then(async function (user) {
        console.log('logged in');
        //console.log(Moralis.User.current());
        user.set("name" , document.getElementById('user-name').value);
        user.set("email", document.getElementById('user-email').value);
        await user.save();
        window.location.href = "dashboard.html";
    })
}

logout = async () => {
    await Moralis.User.logOut();
    window.location.href = "index.html";
}

getTransactions = async () => {

    console.log( "getTransactions clicked");
    const options = { chain: "rinkeby" , address: "0x2C0745a14f9EE4680fD0a842F0251D6816b61F62"};
    const transactions = await Moralis.Web3API.account.getTransactions(options);
    console.log(transactions);

    if(transactions.total > 0) {
        let table = `
        <table class="table">
        <thead>
        <tr>
        <th scope="col">Transaction</th>
        <th scope="col">Block Number</th>
        <th scope="col">Age</th>
        <th scope="col">Type</th>
        <th scope="col">Fee</th>
        <th scope="col">Value</th>
        </tr>
        </thead>
        <tbody id="theTransactions">
        </tbody>
        </table>
        `
        document.querySelector('#tableOfTransactions').innerHTML =  table;
        transactions.result.forEach(t =>{
            let content = `
            <tr>
        <td><a href='https://rinkeby.etherscan.io/tx/${t.hash}' target="_blank" rel="noopener noreferrer"> ${t.hash}</a></td>
        <td><a href='https://rinkeby.etherscan.io/block/${t.block_number}' target="_blank" rel="noopener noreferrer">${t.block_number}<a/></td>
        <td>${millisecondsToTime(Date.parse(new Date()) - Date.parse(t.block_timestamp))}</td>
        <td><a href="">${t.form_address}</a></td>
        <td><a href="">${((t.gas * t.gas_price) / 1e18).toFixed(5)}ETH</a></td>
        <td><a href="">${t.value / 1e18}Eth</a></td>
        </tr>
            `
            theTransactions.innerHTML += content; 
        })
    }
}

getBalances = async () => {
    console.log("Get Balances Clicked");
    const options = {chain: "bsc"};
    const ethBalance = await Moralis.Web3API.account.getNativeBalance();
    const ropstenBalance = await Moralis.Web3API.account.getNativeBalance({chain: "ropsten"});
    const rinkebyBalance = await Moralis.Web3API.account.getNativeBalance({chain: "rinkeby"});
    // console.log((ethBalance.balance / 1e18).toFixed(5) + "ETH");
    // console.log((ropstenBalance.balance / 1e18).toFixed(5) + "ETH");
    // console.log((rinkebyBalance.balance / 1e18).toFixed(5) + "ETH");

    let content = document.querySelector('#tableOfBalances').innerHTML = `
    <table class="table">
        <thead>
        <tr>
        <th scope="col">Chain</th>
        <th scope="col">Balance</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th>Ether</th>
            <td> ${ethBalance.balance / 1e18.toFixed(5)} ETH</td>
        </tr>
        <tr>
            <th>Ropsten</th>
            <td> ${ropstenBalance.balance / 1e18.toFixed(5)} ETH</td>
        </tr>
        <tr>
            <th>Rinkeby</th>
            <td> ${rinkebyBalance.balance / 1e18.toFixed(5)} ETH</td>
        </tr>
        </tbody>
        </table>
    `;

}

getNFTs = async  () => {
    console.log("Get NFTs was clicked");
    let nfts = await Moralis.Web3API.account.getNFTs({ chain: 'rinkeby'});
    console.log(nfts);
    if(nfts.result.length > 0) {
        nfts.result.forEach(n => {
            let metadata = JSON.parse(n.metadata);
        })
    }
}


millisecondsToTime = (ms) => {
    let minutes = Math.floor(ms / (1000 * 60));
    let hours = Math.floor(ms / (1000 * 60 * 60));
    let days = Math.floor(ms / (1000 * 60 * 60 * 24));
    if (days < 1) {
        if(hours  < 1){
            if(minutes < 1) {
                return `less than a minute ago`
            }
            else return `${minutes}  minutes(s)ago`
        }else return `${hours} hours(s) ago`
    }
    else return `${days} days(s) ago`
}

if(document.querySelector('#btn-login') != null){
    document.querySelector('#btn-login').onclick = login;
}
if(document.querySelector('#btn-logout') != null){
document.querySelector('#btn-logout').onclick = logout;
}
if(document.querySelector('#get-transactions') != null) {
    document.querySelector('#get-transactions').onclick =  getTransactions;
}

if(document.querySelector('#get-balances') != null) {
    document.querySelector('#get-balances').onclick = getBalances;
}

if(document.querySelector('#get-nfts') != null) {
    document.querySelector('#get-nfts').onclick = getNFTs;
}


// get-transactions
// get-balances
// get-nfts


