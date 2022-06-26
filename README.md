# Carvensy
(Carpal Tunnel Syndrome Prevention made Easy)
MC2 ADA@BINUS - C5 | iCU (i Care U) - Group 4 Afternoon

## App Architecture

```
carvensy
|
|__ Helper
|
|__ Themes
|  |
|  |__ Colors
|  |
|  |__ Fonts
|  |
|  |__ GIFs
|  |
|  |__ UI
|      |
|      |__ ChooseStretchTableViewCell
|      |
|      |__ MoreComingSoonViewCell
|      |
|      |__ OverviewCollectionViewCell
|      |
|      |__ OverviewSymptomsCollectionViewCell
|      |
|      |__ PainAssessmentViewCell
|      |
|      |__ SymtompsCollectionViewCell
|  
|__ Utilities
|  |
|  |__ Core Data
|       |
|       |__ Helper
|  
|__ Features
   |
   |__ Onboarding
   |    |
   |    |__ Pages
   |        |
   |        |__ Splash
   |        |
   |        |__ OnboardingMain
   |        |
   |        |__ InformationModal
   |
   |__ Breaktimer
   |    |
   |    |__ Pages
   |        |
   |        |__ Break
   |        |
   |        |__ Edit
   |        |
   |        |__ Timer + Overview
   |
   |__ Stretch
   |    |
   |    |__ Model
   |    |   |
   |    |   |__ CreateML Model
   |    |
   |    |__ Pages
   |        |
   |        |__ ChooseStretch
   |        |
   |        |__ DisclaimerStretch
   |        |
   |        |__ DoStretchCamView
   |        |
   |        |__ StretchPraise
   |        |
   |        |__ StretchSteps
   |
   |__ Summary
        |
        |__ Pages
            |
            |__ DailySummary
            |
            |__ PainAssessment
            |
            |__ PostWork

.

.

Each page may have the below architecture:

PageName
|
|__ View
|
|__ Controller


```
