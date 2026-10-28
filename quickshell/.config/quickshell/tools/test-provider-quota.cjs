const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const vm = require("node:vm");

const context = vm.createContext({});
const source = fs.readFileSync(path.join(__dirname, "../components/ProviderQuota.js"), "utf8");
vm.runInContext(source.replace(/^\.pragma library\s*/, ""), context);

const sample = "Provider quota\nSession\n30% left\n⏱ reset in 1h 37m\n\nWeekly\n46% left\n⏱ reset in 5d 17h 2m";
const quota = context.parse(sample);
assert.equal(quota.session.remaining, 30);
assert.equal(quota.session.reset, "1h 37m");
assert.equal(quota.weekly.remaining, 46);
assert.equal(quota.weekly.reset, "5d 17h 2m");
assert.equal(context.parse(sample.replace(/\n/g, "\r\n")).weekly.remaining, 46);
assert.equal(context.parse(sample.replace("30%", "0%")).session.remaining, 0);
assert.equal(context.parse(sample.replace("30%", "100%")).session.remaining, 100);
assert.equal(context.parse(sample.replace("30%", "29.5%")).session.remaining, 29.5);
for (const invalid of ["", "Unauthorized", sample.replace("30%", "101%"), sample.replace("30%", "-1%"), sample.replace("30%", "NaN%"), sample.split("Weekly")[0], sample.replace("⏱ reset in 1h 37m", "")])
    assert.throws(() => context.parse(invalid), /Unexpected provider quota response/);
console.log("Provider quota parser checks passed.");
