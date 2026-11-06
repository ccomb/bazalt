{-# LANGUAGE LambdaCase #-}

{- | Writes one Elm module per Haskell module of the ontology under
@DIR/Ontology@, replacing what was there, then formats them.
-}
module Main (main) where

import Data.HashMap.Lazy qualified as HashMap
import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import Language.Elm.Pretty qualified as Pretty
import Ontology.Elm (definitions)
import Prettyprinter (defaultLayoutOptions, layoutPretty)
import Prettyprinter.Render.Text (renderStrict)
import System.Directory (createDirectoryIfMissing, removePathForcibly)
import System.Environment (getArgs)
import System.Exit (die)
import System.FilePath (takeDirectory, (<.>), (</>))
import System.Process (callProcess)

main :: IO ()
main =
    getArgs >>= \case
        [dir] -> do
            removePathForcibly (dir </> "Ontology")
            mapM_ (write dir) (HashMap.toList $ Pretty.modules definitions)
            callProcess "elm-format" ["--yes", dir </> "Ontology"]
        _ -> die "usage: bazalt-gen-elm OUTPUT_DIRECTORY"
  where
    write dir (path, doc) = do
        let file = foldl (</>) dir (T.unpack <$> path) <.> "elm"
        createDirectoryIfMissing True (takeDirectory file)
        TIO.writeFile file $ renderStrict (layoutPretty defaultLayoutOptions doc)
