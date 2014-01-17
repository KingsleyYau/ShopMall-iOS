//
//  LanguageDef.h
//  MIT Mobile
//
//  Created by fgx_lion on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef MIT_Mobile_LanguageDef_h
#define MIT_Mobile_LanguageDef_h

//#define LANGUAGE_TABLE @"DrPalm"

#define ToLocalizedString(keyString) NSLocalizedString(keyString, nil)
#define ApplictionDisplayName   NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil)

#endif
