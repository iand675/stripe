{-# LANGUAGE OverloadedStrings #-}
-------------------------------------------
-- |
-- Module      : Web.Stripe.Token
-- Copyright   : (c) David Johnson, 2014
-- Maintainer  : djohnson.m@gmail.com
-- Stability   : experimental
-- Portability : POSIX
--
-- < https:/\/\stripe.com/docs/api#tokens >
--
-- @
-- import Web.Stripe         
-- import Web.Stripe.Token
--
-- main :: IO ()
-- main = do
--   let config = SecretKey "secret_key"
--       credit = CardNumber "4242424242424242"
--       em  = ExpMonth 12
--       ey  = ExpYear 2015
--       cvc = CVC "123"
--   result <- stripe config $ createCardToken cn em ey cvc
--   case result of
--     Right token -> print token
--     Left stripeError -> print stripeError
-- @
module Web.Stripe.Token
   ( -- * API
     createCardToken
   , createBankAccountToken
   , getCardToken
   , getBankAccountToken
     -- * Types
   , CardNumber    (..)
   , ExpMonth      (..)
   , ExpYear       (..)
   , CVC           (..)
   , Token         (..)
   , TokenId       (..)
   , TokenType     (..)
   , Country       (..)
   , RoutingNumber (..)
   , AccountNumber (..)
   , Account       (..)
   ) where

import           Web.Stripe.Client.Internal (Method (GET, POST), Stripe,
                                             StripeRequest (..), callAPI,
                                             getParams, toText, (</>))
import           Web.Stripe.Types           (Account(..), AccountNumber (..),
                                             CVC (..), CardNumber (..), 
                                             Country (..), ExpMonth (..), BankAccount(..),
                                             ExpYear (..), RoutingNumber (..), Card(..),
                                             Token (..), TokenId (..), TokenType(..))

------------------------------------------------------------------------------
-- | Create a `Token` by specifiying Credit `Card` information
createCardToken
    :: CardNumber -- ^ Card Number
    -> ExpMonth   -- ^ Card Expiration Month
    -> ExpYear    -- ^ Card Expiration Year
    -> CVC        -- ^ Card CVC
    -> Stripe (Token Card)
createCardToken
      (CardNumber number)
      (ExpMonth month)
      (ExpYear year)
      (CVC cvc)
          = callAPI request
  where request = StripeRequest POST url params
        url     = "tokens"
        params  = getParams [
                    ("card[number]", Just number)
                  , ("card[exp_month]", toText `fmap` Just month)
                  , ("card[exp_year]", toText `fmap` Just year)
                  , ("card[cvc]", Just cvc)
                  ]

------------------------------------------------------------------------------
-- | Create a `Token` for a specific `BankAccount`
createBankAccountToken
    :: Country        -- ^ Country of the `BankAccount` `Token` to retrieve
    -> RoutingNumber  -- ^ Routing Number
    -> AccountNumber  -- ^ Account Number
    -> Stripe (Token BankAccount)
createBankAccountToken
    (Country country)
    (RoutingNumber routingNumber)
    (AccountNumber accountNumber)
    = callAPI request
  where request = StripeRequest POST url params
        url     = "tokens"
        params  = getParams [
                    ("bank_account[country]", Just country)
                  , ("bank_account[routing_number]", Just routingNumber)
                  , ("bank_account[account_number]", Just accountNumber)
                  ]

------------------------------------------------------------------------------
-- | Retrieve a `Token` by `TokenId`
getCardToken 
    :: TokenId -- ^ The `TokenId` of the `Card` `Token` to retrieve
    -> Stripe (Token Card)
getCardToken (TokenId token) = callAPI request
  where request = StripeRequest GET url params
        url     = "tokens" </> token
        params  = []

------------------------------------------------------------------------------
-- | Retrieve a `Token` by `TokenId`
getBankAccountToken
    :: TokenId -- ^ The `TokenId` of the `BankAccount` `Token` to retrieve
    -> Stripe (Token BankAccount)
getBankAccountToken (TokenId token) = callAPI request
  where request = StripeRequest GET url params
        url     = "tokens" </> token
        params  = []








