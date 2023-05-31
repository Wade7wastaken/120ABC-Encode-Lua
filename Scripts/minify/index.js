const luamin = require("luamin");
const fs = require("fs");

// rmSync will error if Output doesn't exist
try {
	fs.rmSync("./Output", { recursive: true });
} catch (error) {
	// This error should be fine, it should just be that Output doesn't exist
	console.log(error);
}

// a simple recursive function that reads all the items in a directory (loc)
// and if it's a file, process it, and if it's a directory
// call this function again
function walkDir(loc) {
	// open the directory
	const dir = fs.opendirSync(loc);
	let dirent;
	// while the next item is not null
	while ((dirent = dir.readSync()) !== null) {
		// if it's a file
		if (dirent.isFile()) {
			const ending = dirent.name.split(".").splice(-1)[0]; // splits the name on every "." and gets the last one
			const path = loc + "/" + dirent.name; // adds the file name to the location

			// only process .lua files
			if (ending === "lua") {
				// assumess all files are utf-8
				const contents = fs.readFileSync(path, "utf8");
				// minify file contents
				let min = luamin.minify(contents);

				const outfile = "./Output" + path.slice(1);
				let outdir = outfile.split("/").slice(0, -1).join("/");

				// create the folders before writing the file
				fs.mkdirSync(outdir, { recursive: true });

				fs.writeFileSync(outfile, min);

				console.log(`Processing file: ${path}`);
			} else {
				console.log(`Skipping non-lua file: ${path}`);
			}

			// if it's a folder, then recursively call the function again
		} else if (dirent.isDirectory()) {
			walkDir(loc + "/" + dirent.name);
		}
	}
	dir.closeSync();
}

walkDir(".");
