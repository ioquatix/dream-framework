#!/usr/bin/env ruby

# https://wiki.mozilla.org/Mobile/Fennec/Android/Clang

require 'rake'
require 'pathname'

class Pathname
	def fullpath!
		unless self.exist?
			self.mkdir
		end
		
		self.realpath
	end
end

NDK_PATH = (Pathname.new(__FILE__).dirname + "android-ndk-r7").fullpath!
NDK_SRC = (Pathname.new(__FILE__).dirname + "android-ndk-r7-src").fullpath!
NDK_CLANG = (Pathname.new(__FILE__).dirname + "android-ndk-r7-clang").fullpath!
CLANG_SRC = (Pathname.new(__FILE__).dirname + "llvm").fullpath!

# Step 1:
sh(NDK_PATH + "build/tools/download-toolchain-sources.sh", NDK_SRC)

# Step 2:
Dir.chdir(NDK_SRC + "binutils") do
	sh("wget", "http://ftp.gnu.org/gnu/binutils/binutils-2.21.1.tar.bz2")
	sh("tar", "-xf", "binutils-2.21.1.tar.bz2")
end

# Step 3:
sh(NDK_PATH + "build/tools/build-gcc.sh", "--binutils-version=2.21.1", "--try-64", NDK_SRC, NDK_CLANG, "arm-linux-androideabi-4.4.3")

# Step 4:
Dir.chdir(CLANG_SRC) do
	sh("svn", "co", "http://llvm.org/svn/llvm-project/llvm/trunk", "llvm")
	Dir.chdir("llvm/tools") do
		sh("svn", "co", "http://llvm.org/svn/llvm-project/cfe/trunk", "clang")
	end
	
	Dir.chdir("llvm") do
		sh("./configure", "--prefix=#{NDK_CLANG}/toolchains/clang", "--enable-optimized", "--enable-targets=x86,arm")
		sh("make", "-j4", "install")
	end
end
