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
from input_files import input_files
process.source = cms.Source("PoolSource",
  fileNames = input_files
  #lumisToProcess = cms.untracked.VLuminosityBlockRange("$run:1-$run:max")
)

process.maxEvents = cms.untracked.PSet(
  #input = cms.untracked.int32(-1)
  input = cms.untracked.int32(4000000)
)

# declare global tag
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')
from Configuration.AlCa.GlobalTag import GlobalTag
#process.GlobalTag = GlobalTag(process.GlobalTag, "106X_dataRun2_testPPS_v1")
process.GlobalTag = GlobalTag(process.GlobalTag, "106X_dataRun2_v26")

# get optics from a DB tag
###   from CondCore.CondDB.CondDB_cfi import *
###   process.CondDBOptics = CondDB.clone( connect = 'frontier://FrontierProd/CMS_CONDITIONS' )
###   process.PoolDBESSourceOptics = cms.ESSource("PoolDBESSource",
###       process.CondDBOptics,
###       DumpStat = cms.untracked.bool(False),
###       toGet = cms.VPSet(cms.PSet(
###           record = cms.string('CTPPSOpticsRcd'),
###           tag = cms.string("PPSOpticalFunctions_offline_v2")
###       )),
###   )
###
###   process.esPreferDBFileOptics = cms.ESPrefer("PoolDBESSource", "PoolDBESSourceOptics")

# get alignment from SQLite file
###   from CondCore.CondDB.CondDB_cfi import *
###   process.CondDBAlignment = CondDB.clone( connect = 'sqlite_file:/afs/cern.ch/user/c/cmora/public/CTPPSDB/AlignmentSQlite/CTPPSRPRealAlignment_table_v26Apr.db' )
###   process.PoolDBESSourceAlignment = cms.ESSource("PoolDBESSource",
###       process.CondDBAlignment,
###       #timetype = cms.untracked.string('runnumber'),
###       toGet = cms.VPSet(cms.PSet(
###           record = cms.string('RPRealAlignmentRecord'),
###           tag = cms.string('CTPPSRPAlignment_real_table_v26A19')
###       ))
###   )
###
###   process.esPreferDBFileAlignment = cms.ESPrefer("PoolDBESSource", "PoolDBESSourceAlignment")

# get alignment from a DB tag
###   from CondCore.CondDB.CondDB_cfi import *
###   process.CondDBAlignment = CondDB.clone( connect = 'frontier://FrontierProd/CMS_CONDITIONS' )
###   process.PoolDBESSourceAlignment = cms.ESSource("PoolDBESSource",
###       process.CondDBAlignment,
###       #timetype = cms.untracked.string('runnumber'),
###       toGet = cms.VPSet(cms.PSet(
###           record = cms.string('RPRealAlignmentRecord'),
###           tag = cms.string('CTPPSRPAlignment_real_offline_v1')
###       ))
###   )
###
###   process.esPreferDBFileAlignment = cms.ESPrefer("PoolDBESSource", "PoolDBESSourceAlignment")

# local RP reconstruction chain with standard settings
process.load("RecoCTPPS.Configuration.recoCTPPS_cff")

if ($year == 2016):
  process.ctppsLocalTrackLiteProducer.includeDiamonds = False
  process.ctppsLocalTrackLiteProducer.includePixels = False

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

# track distribution plotter
process.ctppsTrackDistributionPlotter = cms.EDAnalyzer("CTPPSTrackDistributionPlotter",
    tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),
    outputFile = cms.string("output_tracks.root")
)

# optics plotter
process.ctppsOpticsPlotter = cms.EDAnalyzer("CTPPSOpticsPlotter",
    opticsLabel = cms.string(""),
    outputFile = cms.string("output_optics.root")
)

# processing sequence
if ($year == 2016):
  process.path = cms.Path(
    process.totemRPUVPatternFinder
    * process.totemRPLocalTrackFitter

    * process.ctppsLocalTrackLiteProducer
    * process.ctppsTrackDistributionPlotter

    * process.ctppsProtons
    * process.ctppsProtonReconstructionValidator
    * process.ctppsProtonReconstructionPlotter
    * process.ctppsOpticsPlotter
  )
else:
  process.path = cms.Path(
    process.totemRPUVPatternFinder
    * process.totemRPLocalTrackFitter

    * process.ctppsDiamondRecHits
    * process.ctppsDiamondLocalTracks

    * process.ctppsPixelLocalTracks

    * process.ctppsLocalTrackLiteProducer
    * process.ctppsTrackDistributionPlotter

    * process.ctppsProtons
    * process.ctppsProtonReconstructionValidator
    * process.ctppsProtonReconstructionPlotter
    * process.ctppsOpticsPlotter
  )
