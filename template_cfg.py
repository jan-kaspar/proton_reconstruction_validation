import FWCore.ParameterSet.Config as cms
from Configuration.StandardSequences.Eras import eras
from Configuration.ProcessModifiers.run2_miniAOD_UL_cff import run2_miniAOD_UL

process = cms.Process("CTPPSTestProtonReconstruction", $era_modifiers)

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
)

# apply JSON file
import FWCore.PythonUtilities.LumiList as LumiList
import FWCore.ParameterSet.Types as CfgTypes
process.source.lumisToProcess = CfgTypes.untracked(CfgTypes.VLuminosityBlockRange())
JSONfile = '$json_file'
myLumis = LumiList.LumiList(filename = JSONfile).getCMSSWString().split(',')
process.source.lumisToProcess.extend(myLumis)

# number of events to process
process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(int($max_events))
)

# declare global tag
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, "106X_dataRun2_v29")

# get alignment from a DB tag
#from CondCore.CondDB.CondDB_cfi import *
#process.CondDBAlignment = CondDB.clone(connect = "frontier://FrontierProd/CMS_CONDITIONS")
#process.PoolDBESSourceAlignment = cms.ESSource("PoolDBESSource",
#  process.CondDBAlignment,
#  toGet = cms.VPSet(cms.PSet(
#    record = cms.string("RPRealAlignmentRecord"),
#    tag = cms.string("CTPPSRPAlignment_real_offline_v8")
#  ))
#)
#
#process.esPreferDBFileAlignment = cms.ESPrefer("PoolDBESSource", "PoolDBESSourceAlignment")

# get optics from a DB tag
#from CondCore.CondDB.CondDB_cfi import *
#process.CondDBOptics = CondDB.clone(connect = "frontier://FrontierProd/CMS_CONDITIONS")
#process.PoolDBESSourceOptics = cms.ESSource("PoolDBESSource",
#  process.CondDBOptics,
#  toGet = cms.VPSet(cms.PSet(
#    record = cms.string("CTPPSOpticsRcd"),
#    tag = cms.string("PPSOpticalFunctions_offline_v7")
#  )),
#)
#
#process.esPreferDBFileOptics = cms.ESPrefer("PoolDBESSource", "PoolDBESSourceOptics")

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

  association_cuts_45 = process.ctppsProtons.association_cuts_45,
  association_cuts_56 = process.ctppsProtons.association_cuts_56,

  outputFile = cms.string("output.root")
)

# track distribution plotter
process.ctppsTrackDistributionPlotter = cms.EDAnalyzer("CTPPSTrackDistributionPlotter",
  tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),

  rpId_45_F = process.rpIds.rp_45_F,
  rpId_45_N = process.rpIds.rp_45_N,
  rpId_56_N = process.rpIds.rp_56_N,
  rpId_56_F = process.rpIds.rp_56_F,

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

  rpId_45_F = process.rpIds.rp_45_F,
  rpId_45_N = process.rpIds.rp_45_N,
  rpId_56_N = process.rpIds.rp_56_N,
  rpId_56_F = process.rpIds.rp_56_F,

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

# efficiency estimation
process.load("Validation.CTPPS.ctppsProtonReconstructionEfficiencyEstimatorData_cfi")
process.ctppsProtonReconstructionEfficiencyEstimatorData.tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer")
process.ctppsProtonReconstructionEfficiencyEstimatorData.tagRecoProtonsMultiRP = cms.InputTag("ctppsProtons", "multiRP")

process.ctppsProtonReconstructionEfficiencyEstimatorData.pixelDiscardBXShiftedTracks = process.ctppsProtons.pixelDiscardBXShiftedTracks

process.ctppsProtonReconstructionEfficiencyEstimatorData.localAngleXMin = process.ctppsProtons.localAngleXMin
process.ctppsProtonReconstructionEfficiencyEstimatorData.localAngleXMax = process.ctppsProtons.localAngleXMax
process.ctppsProtonReconstructionEfficiencyEstimatorData.localAngleYMin = process.ctppsProtons.localAngleYMin
process.ctppsProtonReconstructionEfficiencyEstimatorData.localAngleYMax = process.ctppsProtons.localAngleYMax

process.ctppsProtonReconstructionEfficiencyEstimatorData.rpId_45_F = process.rpIds.rp_45_F
process.ctppsProtonReconstructionEfficiencyEstimatorData.rpId_45_N = process.rpIds.rp_45_N
process.ctppsProtonReconstructionEfficiencyEstimatorData.rpId_56_N = process.rpIds.rp_56_N
process.ctppsProtonReconstructionEfficiencyEstimatorData.rpId_56_F = process.rpIds.rp_56_F

process.ctppsProtonReconstructionEfficiencyEstimatorData.outputFile = "output_efficiency.root"

# processing sequences
if ($year == 2016):
  process.seq_reco_loc = cms.Sequence(
    process.totemRPUVPatternFinder
    * process.totemRPLocalTrackFitter
  )
else:
  process.seq_reco_loc = cms.Sequence(
    process.totemRPUVPatternFinder
    * process.totemRPLocalTrackFitter

    * process.ctppsDiamondRecHits
    * process.ctppsDiamondLocalTracks

    * process.ctppsPixelLocalTracks
  )

process.seq_reco_glb = cms.Sequence(
    process.ctppsLocalTrackLiteProducer
    * process.ctppsProtons

    #* process.ctppsEventCategoryPlotter
)

process.seq_anal = cms.Sequence(
    process.ctppsLHCInfoPlotter
    * process.ctppsOpticsPlotter
    * process.ctppsTrackDistributionPlotter
    * process.ctppsProtonReconstructionValidator
    * process.ctppsProtonReconstructionPlotter
    * process.ctppsProtonReconstructionEfficiencyEstimatorData
)

if ($run_reco):
  process.path = cms.Path(
    process.seq_reco_loc
    * process.seq_reco_glb

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
