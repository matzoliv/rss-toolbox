const puppeteer = require('puppeteer');

async function startBrowser() {
    const browser = await puppeteer.launch({
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox'
        ],
    });
    const page = await browser.newPage();
    return {browser, page};
}

async function closeBrowser(browser) {
    return browser.close();
}

async function html2pdf(url) {
    const {browser, page} = await startBrowser();
    await page.emulate({
        viewport: {
            width: 768,
            height: 1024,
            isMobile: true,
            hasTouch: true,
            isLandscape: false,
        },
        userAgent: 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16',
    });
    await page.goto(url);
    await page.pdf({
        printBackground: true,
        path: process.argv[3],
        format: 'A6',
        margin: {top: "0px", bottom: "0px", left: "0px", right: "0px"},
    });
}

(async () => {
    await html2pdf(process.argv[2]);
    process.exit(0);
})();
