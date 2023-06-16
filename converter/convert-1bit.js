const sharp = require('sharp');
const fs = require('fs');

// the value at which given pixel becomes white
const WHITE_TRESHOLD = 128

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

      // Create a new buffer to store the binary data
      const binaryBuffer = Buffer.alloc(Math.ceil(data.length / 8));

      // Iterate over each pixel
      for (let i = 0; i < data.length; i++) {
        const pixelValue = data[i];

        // Calculate the index in the binary buffer
        const bufferIndex = Math.floor(i / 8);

        // Calculate the bit position within the byte
        const bitPosition = 7 - (i % 8);

        // Set the corresponding bit in the binary buffer based on the pixel value
        if (pixelValue > WHITE_TRESHOLD) {
          binaryBuffer[bufferIndex] |= (1 << bitPosition);
        }
      }

      // Define the path to the output binary file
      const outputFilePath = `pics_lua/${filename.split(".")[0]}.bin`;

      // Write the binary buffer to the output file
      fs.writeFile(outputFilePath, binaryBuffer, (err) => {
        if (err) {
          console.error('An error occurred while writing the binary file:', err);
          return;
        }
        console.log('Binary file created successfully.');
      });
    });
}
