# VendingMachine

Using the vending machine we can purchase an NFT.  This would store the NFT onchain and generate an SVG based on the item created.

Basic process
- Request to mint an item by sending payment
- Using a contract create the properties of ththe che item
- Pass these properties to the ERC721 contract to store onchain
- Web server creates visual representation of data on chain as SVG
- Web server provides ERC721 token metadata which points to above SVG image