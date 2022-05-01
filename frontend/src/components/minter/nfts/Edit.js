import React, { useState } from "react";
import PropTypes from "prop-types";
import { Button, Modal, Form, FloatingLabel } from "react-bootstrap";

const EditNft = ({ edit, name, address }) => {
  const [description, setDescription] = useState("");
  const [show, setShow] = useState(false);

  // check if all form data has been filled
  const isFormFilled = () => description;

  // close the popup modal
  const handleClose = () => {
    setShow(false);
  };

  // display the popup modal
  const handleShow = () => setShow(true);

  return (
    <>
      <button className="edit-button" onClick={handleShow}>
        <img className="edit-icon" src="https://img.icons8.com/metro/26/000000/pencil.png" alt="Edit button" />
      </button>

      {/* Modal */}
      <Modal show={show} onHide={handleClose} centered>
        <Modal.Header closeButton>
          <Modal.Title>Update Description</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          <Form>
            <Form.Group className="mb-3">
              <Form.Label>Domain Name</Form.Label>
              <Form.Control
                placeholder={name.toLowerCase()}
                disabled
              />
            </Form.Group>
            <FloatingLabel
              controlId="inputDescription"
              label="Description"
              className="mb-3"
            >
              <Form.Control
                as="textarea"
                placeholder="Description"
                style={{ height: "80px" }}
                onChange={(e) => {
                  setDescription(e.target.value);
                }}
              />
            </FloatingLabel>
          </Form>
        </Modal.Body>

        <Modal.Footer>
          <Button variant="outline-secondary" onClick={handleClose}>
            Close
          </Button>
          <Button
            variant="dark"
            disabled={!isFormFilled()}
            onClick={() => {
              edit({
                name,
                description,
                ownerAddress: address,
              });
              handleClose();
            }}
          >
            Update NFT
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

EditNft.propTypes = {
  edit: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
  address: PropTypes.string.isRequired,
};

export default EditNft;