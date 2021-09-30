const Readability = require('./readability/Readability.js');
const JSDOM = require('jsdom').JSDOM;
const getStdin = require('get-stdin');

getStdin().then(input => {
    const doc = new JSDOM(input, {});
    const reader = new Readability(doc.window.document);
    const article = reader.parse();
    process.stdout.write(article.content);
});

