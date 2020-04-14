/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <TargetConditionals.h>
#if TARGET_OS_IOS

#import "FIRPhoneAuthCredential.h"

#import "FIRAuthCredential_Internal.h"
#import "FIRAuthExceptionUtils.h"
#import "FIRVerifyAssertionRequest.h"

#if TARGET_OS_IOS
#import "FIRPhoneAuthCredential_Internal.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface FIRPhoneAuthCredential ()

- (nullable instancetype)initWithProvider:(NSString *)provider NS_UNAVAILABLE;

@end

@implementation FIRPhoneAuthCredential

- (instancetype)initWithTemporaryProof:(NSString *)temporaryProof
                           phoneNumber:(NSString *)phoneNumber
                            providerID:(NSString *)providerID {
  self = [super initWithProvider:providerID];
  if (self) {
    _temporaryProof = [temporaryProof copy];
    _phoneNumber = [phoneNumber copy];
  }
  return self;
}

- (nullable instancetype)initWithProvider:(NSString *)provider {
  [FIRAuthExceptionUtils
      raiseMethodNotImplementedExceptionWithReason:@"Please call the designated initializer."];
  return nil;
}

- (instancetype)initWithProviderID:(NSString *)providerID
                    verificationID:(NSString *)verificationID
                  verificationCode:(NSString *)verificationCode {
  self = [super initWithProvider:providerID];
  if (self) {
    _verificationID = [verificationID copy];
    _verificationCode = [verificationCode copy];
  }
  return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
  return YES;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
  NSString *verificationID = [aDecoder decodeObjectOfClass:[NSString class]
                                                    forKey:@"verificationID"];
  NSString *verificationCode = [aDecoder decodeObjectOfClass:[NSString class]
                                                      forKey:@"verificationCode"];
  NSString *temporaryProof = [aDecoder decodeObjectOfClass:[NSString class]
                                                    forKey:@"temporaryProof"];
  NSString *phoneNumber = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"phoneNumber"];
  if (temporaryProof.length && phoneNumber.length) {
    self = [self initWithTemporaryProof:temporaryProof
                            phoneNumber:phoneNumber
                             providerID:self.provider];
  } else if (verificationID.length && verificationCode.length) {
    self = [self initWithProviderID:self.provider
                     verificationID:verificationID
                   verificationCode:verificationCode];
  } else {
    self = nil;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.verificationID forKey:@"verificationID"];
  [aCoder encodeObject:self.verificationCode forKey:@"verificationCode"];
  [aCoder encodeObject:self.temporaryProof forKey:@"temporaryProof"];
  [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
}

@end

NS_ASSUME_NONNULL_END

#endif
