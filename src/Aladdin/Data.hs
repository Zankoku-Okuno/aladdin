{-#LANGUAGE GeneralizedNewtypeDeriving, ViewPatterns #-}
module Aladdin.Data (
      Index
    , Val
    , bitcat
    ) where

import Data.Word
import Data.Bits
import Numeric (showHex)

newtype Index = Index Word
    deriving (Eq, Ord, Num, Enum, Real, Integral)

newtype Val = Val Integer
    deriving (Eq, Ord, Num, Bits, Enum, Real, Integral)



bitcat :: Val -> Val -> (Index, Index) -> Val
bitcat high low (from, to) | from < 0
                          || to < 0
                          || from >= to
    = error "Aladdin.Data.bitcat: precondition error"
bitcat high low (fromIntegral -> from, fromIntegral -> to) = a + b
    where
    a = high `shiftL` (to - from)
    b = (low `shiftR` from) .&. (2^(to - from) - 1)


instance Show Index where
    show (Index x) = show x

instance Show Val where
    show (Val x) | x >= 0 = "0x" ++ showHex x ""
                 | otherwise = "-0x" ++ showHex (negate x) ""