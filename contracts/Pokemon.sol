//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Pokemon is VRFConsumerBase {
  bytes32 private _keyHash;
  uint256 private _fee;
  uint256 private constant POKEMON_CONSTANT = 20;

  mapping(bytes32 => address) private _masters;
  mapping(address => uint256) private _results;

  event choosing(address indexed _player, bytes32 indexed _requestID);
  event pokemonChoosen(bytes32 indexed _requestID, uint256 indexed _numValue);

  constructor(
    address _VRFCordinator,
    address _link,
    bytes32 _hash,
    uint256 _taskFee
  )
    VRFConsumerBase(
      0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,
      0x01BE23585060835E02B77ef475b0Cc51aA1e0709
    )
  {
    _keyHash = _hash;
    _fee = _taskFee;
  }

  function choosePokemon(address _player) public returns (bytes32 _requestID) {
    require(LINK.balanceOf(address(this)) > _fee, "Not enough LINK tokens");
    require(_results[_player] == 0, "You have already been given a pokemon");
    _requestID = requestRandomness(_keyHash, _fee);
    _masters[_requestID] = _player;
    _results[_player] = POKEMON_CONSTANT;
    emit choosing(_player, _requestID);
    return _requestID;
  }

  function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
    internal
    override
  {
    uint256 numValue = (_randomness % 100) + 1;
    _results[_masters[_requestId]] = numValue;
    emit pokemonChoosen(_requestId, numValue);
  }

  function _getPokemonName(uint256 id) private pure returns (string memory) {
    string[100] memory pokemons = [
      "Bulbasaur",
      "Ivysaur",
      "Venusaur",
      "Charmander",
      "Charmeleon",
      "Charizard",
      "Squirtle",
      "Wartortle",
      "Blastoise",
      "Caterpie",
      "Metapod",
      "Butterfree",
      "Weedle",
      "Kakuna",
      "Beedrill",
      "Pidgey",
      "Pidgeotto",
      "Pidgeot",
      "Rattata",
      "Raticate",
      "Spearow",
      "Fearow",
      "Ekans",
      "Arbok",
      "Pikachu",
      "Raichu",
      "Sandshrew",
      "Sandslash",
      "Nidoran",
      "Nidorina",
      "Nidoqueen",
      "Nidoran",
      "Nidorino",
      "Nidoking",
      "Clefairy",
      "Clefable",
      "Vulpix",
      "Ninetales",
      "Jigglypuff",
      "Wigglytuff",
      "Zubat",
      "Golbat",
      "Oddish",
      "Gloom",
      "Vileplume",
      "Paras",
      "Parasect",
      "Venonat",
      "Venomoth",
      "Diglett",
      "Dugtrio",
      "Meowth",
      "Persian",
      "Psyduck",
      "Golduck",
      "Mankey",
      "Primeape",
      "Growlithe",
      "Arcanine",
      "Poliwag",
      "Poliwhirl",
      "Poliwrath",
      "Abra",
      "Kadabra",
      "Alakazam",
      "Machop",
      "Machoke",
      "Machamp",
      "Bellsprout",
      "Weepinbell",
      "Victreebel",
      "Tentacool",
      "Tentacruel",
      "Geodude",
      "Graveler",
      "Golem",
      "Ponyta",
      "Rapidash",
      "Slowpoke",
      "Slowbro",
      "Magnemite",
      "Magneton",
      "Farfetch'd",
      "Doduo",
      "Dodrio",
      "Seel",
      "Dewgong",
      "Grimer",
      "Muk",
      "Shellder",
      "Cloyster",
      "Gastly",
      "Haunter",
      "Gengar",
      "Onix",
      "Drowzee",
      "Hypno",
      "Krabby",
      "Kingler",
      "Voltorb"
    ];

    return pokemons[id - 1];
  }

  function pokemonMaster(address _player) public view returns (string memory) {
    require(_results[_player] != 0, "You didn't choose a pokemon");

    require(_results[_player] != POKEMON_CONSTANT, "already a pokemon master");

    return _getPokemonName(_results[_player]);
  }
}
