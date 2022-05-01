import { useContract } from "./useContract";
import DomainNFTAbi from "../contracts/DomainNFT.json";
import DomainNFTContractAddress from "../contracts/DomainNFTAddress.json";

export const useMinterContract = () =>
  useContract(DomainNFTAbi.abi, DomainNFTContractAddress.DomainNFT);

