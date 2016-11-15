#ifndef DRAWBUFFERITEM_H
#define DRAWBUFFERITEM_H

#include <QQuickItem>
#include <QSize>
#include <memory>

class QSGSimpleTextureNode;
class BufferTexture;

class DrawBufferItem : public QQuickItem
{
  Q_OBJECT
public:
  DrawBufferItem( QQuickItem* parent = 0 );
  void* drawBuffer();
  void setBufferSize( QSize size);
protected:
  void geometryChanged(const QRectF & newGeometry,
                       const QRectF & oldGeometry);
  QSGNode* updatePaintNode(QSGNode * oldNode,
                           UpdatePaintNodeData * updatePaintNodeData);
private:
  std::unique_ptr<QSGSimpleTextureNode> mNode;
  std::unique_ptr<BufferTexture> mTexture;
  QSize mTextureSize;
  QRectF mRect;
  bool mRectChanged = false;
  bool mTextureSizeChanged = false;
};

#endif // DRAWBUFFERITEM_H
