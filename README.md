Yes, `easy-rsa` is a popular tool that provides a simpler way of handling certificate creation, especially for VPN setups. It wraps around OpenSSL commands and streamlines the certificate management process. 

Here's a step-by-step guide on how to use `easy-rsa` to generate the root CA and client certificates:

### 1. Install Easy-RSA

If you haven't installed `easy-rsa` yet, you can do so via Homebrew on Mac:

```bash
brew install easy-rsa
```

### 2. Setup the CA

1. **Initialize the PKI (Public Key Infrastructure) directory**:
   
   ```bash
   easyrsa init-pki
   ```

2. **Build the root CA**:
   
   This creates the root certificate (`ca.crt`) and its private key (`ca.key`).

   ```bash
   easyrsa build-ca nopass
   ```

   You'll be prompted to set a passphrase for the CA and fill in some certificate fields. 

### 3. Generate Client Certificates

1. **Generate a private key and CSR for the client**:

   ```bash
   easyrsa gen-req clientname nopass
   ```

   Replace `clientname` with a name specific to the client for whom you're generating the certificate. You'll be prompted to create a passphrase for the client's private key. This generates `clientname.key` and `clientname.csr`.

2. **Sign the client CSR with the root CA**:

   ```bash
   easyrsa sign-req client clientname
   ```

   The tool will ask for the CA passphrase you set in step 2. Once done, this produces the signed client certificate `clientname.crt`.

To generate certificates for additional clients, just repeat the steps under "Generate Client Certificates."

### Notes:

- All generated keys and certificates will be in the `pki` directory that `easy-rsa` creates.
- Keep private keys (from the CA and clients) secure. The CA's private key, in particular, should be kept extremely secure and possibly offline when not in use.
- `easy-rsa` simplifies many complexities, but you still need to ensure proper certificate handling and distribution.

If you're setting up a VPN or any system that requires multiple client certificates, `easy-rsa` can greatly simplify the certificate management process.