/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FIRStartMFAEnrollmentRequest.h"

#import "FIRAuthProtoStartMFAPhoneRequestInfo.h"

static NSString *const kStartMFAEnrollmentEndPoint = @"accounts/mfaEnrollment:start";

@implementation FIRStartMFAEnrollmentRequest

- (nullable instancetype)initWithIDToken:(NSString *)IDToken
                     multiFactorProvider:(NSString *)multiFactorProvider
                          enrollmentInfo:(FIRAuthProtoStartMFAPhoneRequestInfo *)enrollmentInfo
                    requestConfiguration:(FIRAuthRequestConfiguration *)requestConfiguration {
  self = [super initWithEndpoint:kStartMFAEnrollmentEndPoint
            requestConfiguration:requestConfiguration
             useIdentityPlatform:YES
                      useStaging:NO];
  if (self) {
    _IDToken = IDToken;
    _multiFactorProvider = multiFactorProvider;
    _enrollmentInfo = enrollmentInfo;
  }
  return self;
}

- (nullable id)unencodedHTTPRequestBodyWithError:(NSError *__autoreleasing _Nullable *)error {
  NSMutableDictionary *postBody = [NSMutableDictionary dictionary];
  if (_IDToken) {
    postBody[@"idToken"] = _IDToken;
  }
  if (_multiFactorProvider) {
    postBody[@"mfaProvider"] = _multiFactorProvider;
  }
  if (_enrollmentInfo) {
    if ([_enrollmentInfo isKindOfClass:[FIRAuthProtoStartMFAPhoneRequestInfo class]]) {
      postBody[@"phoneEnrollmentInfo"] = [_enrollmentInfo dictionary];
    }
  }
  return [postBody copy];
}

@end
