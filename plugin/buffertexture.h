#ifndef BUFFERTEXTURE_H
#define BUFFERTEXTURE_H

#include <QSGDynamicTexture>
#include <QMutex>

class BufferTexture : public QSGDynamicTexture
{
  Q_OBJECT
public:
  BufferTexture( QSize bufferSize );
  ~BufferTexture();
  bool updateTexture() override final;
  void bind() override final;
  bool hasAlphaChannel() const override final;
  bool hasMipmaps() const override final;
  int textureId() const override final;
  QSize textureSize() const override final;
  void* buffer();
  void releaseBuffer();
private:
  quint32 texId_ = 0;
  QSize size_;
  void *buffer_ = nullptr;
  QMutex bufferMutex_;
  bool bufferWasUsed_ = false;

};

#endif // BUFFERTEXTURE_H
