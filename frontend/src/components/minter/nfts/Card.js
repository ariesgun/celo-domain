import { useContractKit } from '@celo-tools/use-contractkit';
import React from "react";
import PropTypes from "prop-types";
import { Card, Col, Badge, Stack, Row } from "react-bootstrap";
import { truncateAddress } from "../../../utils";
import Identicon from "../../ui/Identicon";
import EditNft from "./Edit";

const NftCard = ({ nft, edit }) => {
  
  const { _, address } = useContractKit();
  const { image, description, owner, name, index } = nft;

  return (
    <Col key={index}>
      <Card className=" h-100">
        <Card.Header>
          <Stack direction="horizontal" gap={2}>
            <Identicon address={owner} size={28} />
            <span className="font-monospace text-secondary">
              {truncateAddress(owner)}
            </span>
          </Stack>
        </Card.Header>

        <img src={image} alt={description} />
        
        <Card.Body className="d-flex  flex-column text-center">
          <Card.Title>{name.toLowerCase()}</Card.Title>
            <Stack direction="horizontal" gap={2} className="mx-auto">
              <Card.Text className="flex-grow-1 mb-1 pt-1">{description}</Card.Text>
              {/* If mint.owner is currentAccount, add an "edit" button*/}
              { owner.toLowerCase() === address.toLowerCase() ?
                <EditNft edit={edit} name={name} address={address} />
                :
                null
              }
            </Stack>
        </Card.Body>
      </Card>
    </Col>
  );
};

NftCard.propTypes = {
  // props passed into this component
  nft: PropTypes.instanceOf(Object).isRequired,
  edit: PropTypes.func.isRequired,
};

export default NftCard;