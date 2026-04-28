# Audit Fair Casino
### Première étape : Observation
Dans un premier temps j'ai été observer le site et son fonctionnement, puis j'ai essayé de faire une partie en connectant mon wallet metamask créé pour l'occasion du cours. J'ai perdu mais peu importe je voulais simplement avoir testé la fonctionnalité.

J'ai par la suite été lire le code du contrat 0xed5415679D46415f6f9a82677F8F4E9ed9D1302b qui est le code backend du site pour mieux comprendre comment le jeu fonctionnait mais surtout pour essayer de trouver des failles potentielles.

Puis en cherchant j'ai fini par repenser au dernier cours et en voyant que le contrat se servait d'un Oracle pour la génération du numéro gagnant et je vais maintenant commencer a essayer d'exploiter cette faille.

 ### Deuxième étape : Exploit
Après investigation plus poussé je n'ai pas réussi a exploiter l'Oracle mais cela m'a permis de comprendre que je pouvais quand même deviner le chiffre aléatoire généré,  le chiffre étant calculé par cette formule $$winningNumber = uint256(keccak256(abi.encodePacked(secretTarget \oplus price, gameSalt, currentRound)))$$
#### 1) secretTarget et gameSalt
Nous savons que secretTarget et gamesSalt sont des variables private mais vous nous avez expliqué que ceci ne protège pas la valeur dans le cas des smart contrat, j'ai donc cherché comment les récupérer, en fouillant dans le contrat sur https://sepolia.etherscan.io/address/0xed5415679D46415f6f9a82677F8F4E9ed9D1302b#code
j'ai trouvé les arguments passé au constructeur
-----Decoded View---------------  
Arg [0] : _target (uint256): 463646446423265643233525262662355635362666463  
Arg [1] : _oracle (address):  0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
Arg [2] : _salt (uint256): 7192271  
  
Grâce a ces valeurs je vais pouvoir écrire un contrat utilisant la même méthode de calcul du chiffre aléatoire que FairCasino, mon contrat aura donc besoin des adresses du contrat visé qui va me servir a récupérer **currentRound** et l'adresse de l'oracle qui me permettra de récupérer **price**
#### 2) Ecriture du contrat
J'ai pris mon temps pour écrire le contrat en testant peu a peu j'ai remarqué que je n'avais pas pris une autre part en compte, le dans **FairCasino.sol** pour jouer le contrat exige une signature égale a **0xbeef** calculable grâce a un nonce et j'ai donc écrit une fonction pour bruteforce le nonce a partir du chiffre gagnant et du numéro de round.
#### 3) Exécution
J'ai compilé et déployé le contrat test_2.sol sur le réseau sepolia
### Le code se trouve dans mon répo git ou a l'adresse 0x143b3875D5F1EfA12E85fd097463363849113Af8
Après avoir essayé j'ai remarqué que mon contrat n'est pas assez optimisé pour faire 3 fois le calcul du nonce sans atteindre la limite de gaz en une seule transaction et je n'ai réussi qu'a faire fonctionner l'exploit une seule fois.

https://sepolia.etherscan.io/tx/0xf08e07b231465ead1ae4bfc17050d21e732b4dba6674888cc17b9a6961e94db3

Ici se trouve l'exemple d'une transaction ayant réussi ou l'on peux observer que 0.01 ETH sont envoyés, 0.1 ETH sont reçu puis la répartition a bien lieu 50/30/20 entre les lieutenants.
