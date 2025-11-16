import qualified Data.ByteString.Lazy as BLazy
import qualified Data.ByteString.Builder as Builder
import Data.Foldable
import Text.Printf (printf)
import System.Process (runCommand)



volume::Float
volume = 0.5

outputFilePath :: FilePath
outputFilePath = "output.bin"

sampleRate :: Float
sampleRate = 48000.0


wave :: [Float]
wave = map (*volume) $ map sin $ map (*step) [0.0 .. sampleRate]
  where step = 0.01

mini_wave :: [Float]
mini_wave = map (*volume) $ map sin $ map (*step) [0.0 .. 10]
  where step = 0.01

save :: FilePath -> IO()
save filePath = BLazy.writeFile filePath $ Builder.toLazyByteString $ fold $ map Builder.floatLE wave

play ::IO()
play = do 
  save outputFilePath
  _ <- runCommand $ printf "ffmpeg -f f32le -ar %f -i %s output.wav" sampleRate outputFilePath
  --_ <- runCommand $ printf "ffplay -f f32le -ar 48000" outputFilePath
  return ()


--B.toLazyByteString $ fold $ map B.floatLE wave
