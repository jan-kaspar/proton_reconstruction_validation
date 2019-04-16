import FWCore.ParameterSet.Config as cms
from Configuration.StandardSequences.Eras import eras

process = cms.Process("CTPPSTestProtonReconstruction", eras.ctpps_2016)

# minimum of logs
process.MessageLogger = cms.Service("MessageLogger",
  statistics = cms.untracked.vstring(),
  destinations = cms.untracked.vstring("cout"),
  cout = cms.untracked.PSet(
    threshold = cms.untracked.string("WARNING")
  )
)

# raw data source
process.source = cms.Source("PoolSource",
  fileNames = cms.untracked.vstring()
  #lumisToProcess = cms.untracked.VLuminosityBlockRange("$run:1-$run:max")
)
$input

process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(-1)
)

# declare global tag
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, "105X_dataRun2_relval_v2")
#process.GlobalTag = GlobalTag(process.GlobalTag, "auto:run2_data")

# local RP reconstruction chain with standard settings
process.load("RecoCTPPS.Configuration.recoCTPPS_cff")

##  process.ctppsRPAlignmentCorrectionsDataESSourceXML.RealFiles = cms.vstring(
##    #"CalibPPS/ESProducers/data/alignment/RPixGeometryCorrections_old.xml",
##    "CalibPPS/ESProducers/data/alignment/RPixGeometryCorrections-2017-2018.xml",
##    #"CalibPPS/ESProducers/data/alignment/alignment_export_2019_03_18.5.xml",
##    "CalibPPS/ESProducers/data/alignment/alignment_export_2019_04_15.1.xml",
##    "CalibPPS/ESProducers/data/alignment/timing_RP_2017_preTS2.xml",
##    "CalibPPS/ESProducers/data/alignment/timing_RP_2017_postTS2.xml",
##    "CalibPPS/ESProducers/data/alignment/timing_RP_2018.xml"
##  )

# reconstruction validator
process.ctppsProtonReconstructionValidator = cms.EDAnalyzer("CTPPSProtonReconstructionValidator",
    tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),
    tagRecoProtons = cms.InputTag("ctppsProtons", "multiRP"),

    chiSqCut = cms.double(2.),

    outputFile = cms.string("output_validation.root")
)

# reconstruction plotter
process.ctppsProtonReconstructionPlotter = cms.EDAnalyzer("CTPPSProtonReconstructionPlotter",
    tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),
    tagRecoProtonsSingleRP = cms.InputTag("ctppsProtons", "singleRP"),
    tagRecoProtonsMultiRP = cms.InputTag("ctppsProtons", "multiRP"),

    rpId_45_F = cms.uint32(0),
    rpId_45_N = cms.uint32(0),
    rpId_56_N = cms.uint32(0),
    rpId_56_F = cms.uint32(0),

    outputFile = cms.string("$output")
)

if ($year == 2016):
  process.ctppsProtonReconstructionPlotter.rpId_45_F = 3
  process.ctppsProtonReconstructionPlotter.rpId_45_N = 2
  process.ctppsProtonReconstructionPlotter.rpId_56_N = 102
  process.ctppsProtonReconstructionPlotter.rpId_56_F = 103
else:
  process.ctppsProtonReconstructionPlotter.rpId_45_F = 23
  process.ctppsProtonReconstructionPlotter.rpId_45_N = 3
  process.ctppsProtonReconstructionPlotter.rpId_56_N = 103
  process.ctppsProtonReconstructionPlotter.rpId_56_F = 123

process.path = cms.Path(
  process.totemRPUVPatternFinder
  * process.totemRPLocalTrackFitter

  * process.ctppsDiamondRecHits
  * process.ctppsDiamondLocalTracks

  * process.ctppsPixelLocalTracks

  * process.ctppsLocalTrackLiteProducer

  * process.ctppsProtons
  #* process.ctppsProtonReconstructionValidator
  * process.ctppsProtonReconstructionPlotter
)
