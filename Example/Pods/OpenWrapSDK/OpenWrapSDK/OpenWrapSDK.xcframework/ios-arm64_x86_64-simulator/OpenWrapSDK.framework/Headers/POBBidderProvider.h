/*
* PubMatic Inc. ("PubMatic") CONFIDENTIAL
* Unpublished Copyright (c) 2006-2023 PubMatic, All Rights Reserved.
*
* NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
* herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
* Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
* from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
* Confidentiality and Non-disclosure agreements explicitly covering such access or to such other persons whom are directly authorized by PubMatic to access the source code and are subject to confidentiality and nondisclosure obligations with respect to the source code.
*
* The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
* information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
* OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PUBMATIC IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
* LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
* TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
*/

#import <Foundation/Foundation.h>

#ifndef POBBidderProvider_h
#define POBBidderProvider_h


@class POBPartnerInfo;
@protocol POBBidding;
@protocol POBPartnerInstantiator;
/*!
  Lists the method for interacting with provider to get bidders for provided bidder name
 */
@protocol POBBidderProvider <NSObject>

/*!
  @abstract Return the  the bidder object
  @param partnerId The partner name for which bidder is needed
  @param request The Request instance
  @param partnerInfo The partnerInfo containing bidder specific details
  @param config ad configuration required to initialise bidder/renderer for the partner
  @result partner object conforming to POBPartnerInstantiator
 */
- (id<POBPartnerInstantiator>)partnerWithId:(NSString *)partnerId
                                    request:(NSObject *)request
                             bidderSlotInfo:(POBPartnerInfo *)partnerInfo
                                   adConfig:(POBAdConfiguration*)config;
@end
#endif /* POBBidderProvider_h */
