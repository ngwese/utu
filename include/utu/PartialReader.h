//
// Copyright (c) 2021 Greg Wuller.
//
// SPDX-License-Identifier: GPL-2.0-or-later
//

#pragma once

#include <optional>
#include <string>

#include "utu/PartialData.h"

namespace utu
{

struct PartialReader
{
  static std::optional<PartialData> read(const std::string& jsonData);
};

}  // namespace utu