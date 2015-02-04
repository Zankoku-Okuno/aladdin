module Aladdin.Micro where

import Data.List (intercalate)
import Aladdin.Data

data MicroOp =
      Store Loc Expr
    | Jump Loc
    | Cond Expr MicroOp (Maybe MicroOp)
    | Let String Expr

data Loc = 
      Register String
    | RegBit String IExpr
    | CompAddr Expr

data Expr =
      Imm Val
    | Contents Loc
    | BitIx Expr IExpr
    | BitCat Val Val (IExpr, IExpr)
    | Oper Oper [Expr]
    | LocalVar String

data Oper =
      Add | Sub
    | Mul | Div
    | Invert
    | And | Or | Xor
    | Eq | Neq | Gt | Lt | Gte | Lte
    | ShL | ShR
    --TODO plenty more, like popcounts, floating-point ops
    deriving (Eq, Show)

type IExpr = Index --FIXME should accept IndexExpr, not just Index

--TODO check equivalence, probably a normal-form for Expr

instance Show Loc where
    show (Register name) = name
    show (RegBit name i) = name ++ "[" ++ show i ++ "]"
    show (CompAddr e) = "(" ++ show e ++ ")"

instance Show Expr where
    show (Imm val) = show val
    show (Contents loc) = "*" ++ show loc
    show (BitCat high low (from, to)) = show high ++ ":" ++ show low ++ "[" ++ show from ++ ":" ++ show to ++ "]"
    show (Oper o es) = show o ++ "(" ++ intercalate ", " (map show es) ++ ")"
    show (LocalVar name) = name