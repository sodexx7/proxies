## Proxies

- [RelatedQuestions](RelatedQuestions.md)

- [Ethernaut](Ethernaut.md)

- [Week2_upgradeable](UpgradeableWeek2Protocols.md)

- [DelegatecallDifferentSituationsTries](DelegatecallDifferentSituationsTries.md)

- [damn-vulnerable-defi-CTF](damn-vulnerable-defi-CTF.md)

### Materials

- https://proxies.yacademy.dev/pages/security-guide/#uninitialized-proxy-vulnerability. more tools and cases can check. like how to check the storage layout

- [Related with the proxy](proxyOther.md)

- if use javascript do testing, sometimes can't can get the return contract. As return proxy in backDoor, so can use npx hardhat console --network localhost. get the event info which inculdes the related address

### todo

- For the backDoor, how to use the signaute feature? how to deal with the payment? how to deal with the gas?
- What's the meaning of using ModuleManager(setupModules(to, data)) related with the backDoor?

2. what's the meaning with below code, why using the linked list data structure? OwnerManager
   ```
   mapping(address => address) internal owners;
   ```
