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
  input = cms.untracked.int32($max_events)
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

# define RP ids
process.rpIds = cms.PSet()

if ($year == 2016):
  process.rpIds.rp_45_F = cms.uint32(3)
  process.rpIds.rp_45_N = cms.uint32(2)
  process.rpIds.rp_56_N = cms.uint32(102)
  process.rpIds.rp_56_F = cms.uint32(103)
else:
  process.rpIds.rp_45_F = cms.uint32(23)
  process.rpIds.rp_45_N = cms.uint32(3)
  process.rpIds.rp_56_N = cms.uint32(103)
  process.rpIds.rp_56_F = cms.uint32(123)

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

  rpId_45_F = process.rpIds.rp_45_F,
  rpId_45_N = process.rpIds.rp_45_N,
  rpId_56_N = process.rpIds.rp_56_N,
  rpId_56_F = process.rpIds.rp_56_F,

  outputFile = cms.string("$output")
)

# track distribution plotter
process.ctppsTrackDistributionPlotter = cms.EDAnalyzer("CTPPSTrackDistributionPlotter",
  tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),
  outputFile = cms.string("output_tracks.root")
)

# xangle and beta* plotter
process.ctppsLHCInfoPlotter = cms.EDAnalyzer("CTPPSLHCInfoPlotter",
  lhcInfoLabel = cms.string(""),
  outputFile = cms.string("output_lhcInfo.root"),
)

# optics plotter
process.ctppsOpticsPlotter = cms.EDAnalyzer("CTPPSOpticsPlotter",
  opticsLabel = cms.string(""),
  outputFile = cms.string("output_optics.root")
)

# event category plotter
###   process.ctppsEventCategoryPlotter = cms.EDAnalyzer("CTPPSEventCategoryPlotter",
###     tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),
###     tagStripHits = cms.InputTag("totemRPRecHitProducer"),
###     tagStripPatterns = cms.InputTag("totemRPUVPatternFinder"),
###     tagRecoProtonsMultiRP = cms.InputTag("ctppsProtons", "multiRP"),
###   
###     rpId_45_F = process.rpIds.rp_45_F,
###     rpId_45_N = process.rpIds.rp_45_N,
###     rpId_56_N = process.rpIds.rp_56_N,
###     rpId_56_F = process.rpIds.rp_56_F,
###   
###     outputFile = cms.string("output_categories.root")
###   )

# processing sequence
if ($year == 2016):
  process.seq_reco = cms.Sequence(
    process.totemRPUVPatternFinder
    * process.totemRPLocalTrackFitter

    * process.ctppsLocalTrackLiteProducer
    * process.ctppsProtons
  )
else:
  process.seq_reco = cms.Sequence(
    process.totemRPUVPatternFinder
    * process.totemRPLocalTrackFitter

    * process.ctppsDiamondRecHits
    * process.ctppsDiamondLocalTracks

    * process.ctppsPixelLocalTracks

    * process.ctppsLocalTrackLiteProducer
    * process.ctppsProtons
  )

process.seq_anal = cms.Sequence(
    process.ctppsLHCInfoPlotter
    * process.ctppsOpticsPlotter
    * process.ctppsTrackDistributionPlotter
    * process.ctppsProtonReconstructionValidator
    * process.ctppsProtonReconstructionPlotter
    #* process.ctppsEventCategoryPlotter
)

if ($run_reco):
  process.path = cms.Path(
    process.seq_reco
    * process.seq_anal
  )
else:
  process.path = cms.Path(
    process.seq_anal
  )

# output configuration
###   process.maxEvents.input = cms.untracked.int32(10000)
###
###   process.output = cms.OutputModule("PoolOutputModule",
###     fileName = cms.untracked.string("output_edm.root"),
###     outputCommands = cms.untracked.vstring(
###       "drop *",
###       'keep recoForwardProtons_*_*_*'
###     )
###   )
###   
###   process.outpath = cms.EndPath(process.output)
