interface FeatureConfig {
    minVersion: string; 
  }

interface FeaturesConfig {
    [featureName: string]: FeatureConfig; 
  }