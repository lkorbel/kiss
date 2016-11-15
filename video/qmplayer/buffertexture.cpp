#include "buffertexture.h"
#include <QMutexLocker>
#include <QOpenGLFunctions>

/*!
 * \class BufferTexture
 * \brief Texture class with direct buffer access
 *
 * Currently buffer is desinged to use RGBA data
 */

BufferTexture::BufferTexture( QSize bufferSize ) :
  size_(bufferSize)
{
  glGenBuffers( 1, &texId_ );
  glBindBuffer( GL_TEXTURE_BUFFER, texId_);
  int size = size_.width() * size_.height() * sizeof(quint32);
  QByteArray initialData( size, 0);
  glBufferData( texId_, size, initialData.constData(), GL_STREAM_DRAW);
  buffer_ =glMapBufferRange( texId_, 0, size, GL_MAP_WRITE_BIT);
}

BufferTexture::~BufferTexture()
{
  glUnmapBuffer( GL_TEXTURE_BUFFER );
  glDeleteBuffers( 1, &texId_ );
}

bool BufferTexture::updateTexture()
{
  QMutexLocker locker(&bufferMutex_);
  if (bufferWasUsed_) {
    bufferWasUsed_ = false;
    return true;
  }
  return false;
}

void BufferTexture::bind()
{
  glBindBuffer( GL_TEXTURE_BUFFER, texId_);
  glTexBuffer( GL_TEXTURE_BUFFER, GL_RGBA32I, texId_); //unfortunately this is in API 4.3
}

bool BufferTexture::hasAlphaChannel() const
{
  return true;
}

bool BufferTexture::hasMipmaps() const
{
  return false;
}

int BufferTexture::textureId() const
{
  return texId_;
}

QSize BufferTexture::textureSize() const
{
  return size_;
}

/*!
 * \brief access buffer
 * \return GL buffer
 *
 * Each call to method should have corresponding
 * relaseBuffer call in code!
 * \sa releaseBuffer
 */
void* BufferTexture::buffer()
{
  bufferMutex_.lock();
  return buffer_;
}

/*!
 * \brief mark buffer usable
 *
 * Indicates that buffer is ready to use again.
 * Call this method after finishing operation on memory
 * returned by \c buffer
 */
void BufferTexture::releaseBuffer()
{
  bufferWasUsed_ = true;
  bufferMutex_.unlock();
}
