.pragma library

function parse(text) {
    const lines = text.trim().split(/\r?\n/).map(line => line.trim()).filter(line => line.length > 0);
    const result = {};
    for (const name of ["Session", "Weekly"]) {
        const index = lines.indexOf(name);
        const match = index >= 0 && (lines[index + 1] || "").match(/^(\d+(?:\.\d+)?)% left$/);
        const reset = index >= 0 && (lines[index + 2] || "").match(/^(?:⏱\s*)?reset in (.+)$/);
        if (!match || !reset || Number(match[1]) > 100)
            throw new Error("Unexpected provider quota response.");
        result[name.toLowerCase()] = {
            remaining: Number(match[1]),
            reset: reset[1].replace(/(^|\s)(\d)m\b/g, (_, prefix, minute) => prefix + "0" + minute + "m")
        };
    }
    return result;
}
