/**
 * PasswordMaker - Creates and manages passwords
 * Copyright (C) 2005 Eric H. Jung and LeahScape, Inc.
 * http://passwordmaker.org/
 * grimholtz@yahoo.com
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at
 * your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESSFOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Written by Miquel Burns <miquelfire@gmail.com> and Eric H. Jung
 * Modified by James Stapleton<jstaplet@tasermonkeys.com> for easy use in objective-c
 */

// https://github.com/shultzc/iphone-passwordmaker/blob/12a472eb01a5a7de5c6087c06e13778db629d4bd/Sources/Classes/leet.m

#import <Foundation/Foundation.h>
#define kNUMBER_OF_OBJECTS  26

// convert message to l33t-speak
NSString* leetConvert(int level, NSString* message);
NSString * convertLeet(int level, NSString* message);
