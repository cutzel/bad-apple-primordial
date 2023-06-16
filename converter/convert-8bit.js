const sharp = require('sharp');
const fs = require('fs');

for (let filename of fs.readdirSync("pics")) {
  // Define the path to the input image
  const inputImagePath = `pics/${filename}`;

  // Read the input image using Sharp
  sharp(inputImagePath)
    .greyscale() // Convert image to grayscale if it's not already
    .raw() // Output raw pixel data
    .toBuffer((err, data, info) => {
      if (err) {
        console.error('An error occurred while processing the image:', err);
        return;
      }

      // Define the path to the output binary file
      const outputFilePath = `pics_lua/${filename.split(".")[0]}.bin`;

      // Write the binary buffer to the output file
      fs.writeFile(outputFilePath, data, (err) => {
        if (err) {
          console.error('An error occurred while writing the binary file:', err);
          return;
        }
        console.log('Binary file created successfully.');
      });
    });
}
