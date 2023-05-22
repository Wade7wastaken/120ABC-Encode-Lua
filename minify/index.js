const luamin = require("luamin");
const fs = require("fs");

// rmSync will error if Output doesn't exist
try {
	fs.rmSync("./Output", { recursive: true });
} catch (error) {
	console.log(error);
}

// a simple recursive function that reads all the items in a directory (loc)
// and if it's a file, process it, and if it's a directory
// call this function again
function loop(loc) {
	const dir = fs.opendirSync(loc);
	let dirent;
	// while the next item is not null
	while ((dirent = dir.readSync()) !== null) {
		// filter out git and other hidden files and directories

		if (dirent.isFile()) {
			const ending = dirent.name.split(".").splice(-1)[0]; // splits the name on every "." and gets the last one
			const path = loc + "/" + dirent.name; // adds the file name to the location

			if (ending === "lua") {
				const contents = fs.readFileSync(path, "utf8");
				let min = luamin.minify(contents);

				const outfile = "./Output" + path.slice(1);
				let outdir = outfile.split("/").slice(0, -1).join("/");

				// create the folders before writing the file

				fs.mkdirSync(outdir, { recursive: true });

				fs.writeFileSync(outfile, min);

				console.log("File: " + path);
			}

			// if it's a folder, then recursively call the function again
		} else if (dirent.isDirectory()) {
			loop(loc + "/" + dirent.name);
		}
	}
	dir.closeSync();
}

loop(".");
